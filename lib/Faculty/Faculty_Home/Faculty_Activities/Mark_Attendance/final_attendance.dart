import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MarkAttendance extends StatefulWidget {
  final String class_name;
  final String section;

  MarkAttendance({required this.class_name, required this.section});

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final databaseRef = FirebaseDatabase.instance.ref("Classroom");
  Map<String, Map<String, dynamic>> attendance = {};
  String attendanceDate = DateTime.now().toIso8601String().split('T').first; // current date in YYYY-MM-DD format

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() {
    databaseRef.child(widget.class_name).child(widget.section).onValue.listen((event) {
      if (event.snapshot.exists) {
        var data = event.snapshot.value;
        if (data is Map) {
          Map<String, dynamic> students = Map<String, dynamic>.from(data);
          setState(() {
            attendance = {
              for (var key in students.keys)
                key: {'name': students[key]['name'] ?? 'No Name', 'present': false}
            };
          });
        } else if (data is List) {
          // Convert list to map, ignoring null values
          Map<String, dynamic> students = {
            for (int i = 0; i < data.length; i++)
              if (data[i] != null) data[i]['roll_no'].toString(): data[i]
          };
          setState(() {
            attendance = {
              for (var key in students.keys)
                key: {'name': students[key]['name'] ?? 'No Name', 'present': false}
            };
          });
        } else {
          print("Unexpected data format: $data");
        }
      } else {
        print("No students found for ${widget.class_name} - ${widget.section}");
      }
    });
  }

  void saveAttendance() {
    Map<String, dynamic> updates = {};
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    attendance.forEach((rollNo, details) {
      updates["${widget.class_name}/${widget.section}/$rollNo/attendance/$timestamp"] = {
        "status": details['present'] ? "Present" : "Absent",
        "date": attendanceDate
      };
    });

    databaseRef.update(updates).then((_) {
      print("Attendance saved");
      Navigator.pop(context); // Go back to the previous screen after saving
    }).catchError((error) {
      print("Failed to save attendance: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Mark Attendance",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: attendance.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              itemCount: attendance.length,
              itemBuilder: (context, index) {
                String rollNo = attendance.keys.elementAt(index);
                String name = attendance[rollNo]!['name'] ?? 'No Name';
                bool isPresent = attendance[rollNo]!['present'];

                return Card(
                  color: Colors.blueGrey.shade100,
                  child: ListTile(
                    leading: Text(rollNo,style: TextStyle(fontSize: 16),),
                    title: Text(name),
                    trailing: Checkbox(
                      value: isPresent,
                      onChanged: (value) {
                        setState(() {
                          attendance[rollNo]!['present'] = value!;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      backgroundColor: Colors.blueGrey.shade700,
      floatingActionButton: FloatingActionButton(
        onPressed: saveAttendance,
        foregroundColor: Colors.blueGrey.shade700,
        backgroundColor: Colors.white,
        child:Icon(Icons.save,size: 35,),
      ),
    );
  }
}
