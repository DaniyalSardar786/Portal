import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SpecificStudentAttendanceScreen extends StatefulWidget {
  final String roll_no;
  final String class_name;
  final String section;

  const SpecificStudentAttendanceScreen({
    super.key,
    required this.roll_no,
    required this.class_name,
    required this.section,
  });

  @override
  State<SpecificStudentAttendanceScreen> createState() =>
      _SpecificStudentAttendanceScreenState();
}

class _SpecificStudentAttendanceScreenState
    extends State<SpecificStudentAttendanceScreen> {
  final databaseRef = FirebaseDatabase.instance.ref("Classroom");
  Map<String, dynamic> attendanceRecords = {};
  int presentCount = 0;
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    fetchAttendanceRecords();
  }

  void fetchAttendanceRecords() {
    databaseRef
        .child(widget.class_name)
        .child(widget.section)
        .child(widget.roll_no)
        .child('attendance')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        var data = event.snapshot.value;
        if (data is Map) {
          setState(() {
            attendanceRecords = data.map((key, value) =>
                MapEntry(key.toString(), Map<String, dynamic>.from(value)));
            calculateAttendancePercentage();
          });
        } else {
          print("Unexpected data format: $data");
        }
      } else {
        print("No attendance records found for ${widget.roll_no}");
      }
    });
  }

  void calculateAttendancePercentage() {
    presentCount = 0;
    totalCount = attendanceRecords.length;

    attendanceRecords.forEach((key, value) {
      if (value['status'] == 'Present') {
        presentCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double attendancePercentage =
        totalCount > 0 ? (presentCount / totalCount) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: attendanceRecords.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade300,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.white, blurRadius: 5)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Attendance: ${attendancePercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade800),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: attendanceRecords.length,
                        itemBuilder: (context, index) {
                          String timestamp =
                              attendanceRecords.keys.elementAt(index);
                          Map<String, dynamic> record =
                              attendanceRecords[timestamp];
                          String date = record['date'] ?? 'Unknown Date';
                          String status = record['status'] ?? 'Unknown Status';

                          return Card(
                            child: ListTile(
                              trailing: Text(date),
                              title: Text(
                                'Status: $status',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
