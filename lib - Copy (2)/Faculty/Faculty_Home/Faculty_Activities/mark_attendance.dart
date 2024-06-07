import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:portal/Faculty/Faculty_Home/Faculty_Activities/Mark_Attendance/final_attendance.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final String teacherId;
  const MarkAttendanceScreen({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final DatabaseReference _ref = FirebaseDatabase.instance.reference();
  String? assignedClasses;
  String? sections;

  @override
  void initState() {
    super.initState();
    fetchAssignedClasses();
  }

  Future<void> fetchAssignedClasses() async {
    final snapshot = await _ref.child("Teachers").child(widget.teacherId).child("assignedClass").get();
    if (snapshot.value != null) {
      final assignedClass = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        assignedClasses =assignedClass["class"];
        sections = assignedClass["section"];
      });
    }
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          if (assignedClasses==null)
            const Center(
              child: Text(
                "No classes assigned to this teacher",
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                final assignedClass = assignedClasses;
                final section = sections;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 5
                      )
                    ]
                  ),
                  child: ListTile(
                    title: Text("Class: $assignedClass"),
                    subtitle: Text("Section: $section"),
                    trailing:ElevatedButton(
                      onPressed: (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MarkAttendance(class_name: assignedClass.toString(), section: section.toString(),)));
                        });
                      },
                      child: Text("Mark Attendance"),
                    )
                  ),
                );
              },
            ),
        ],
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
