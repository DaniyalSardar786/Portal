import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:portal/Faculty/Faculty_Home/Faculty_Activities/Mark_Attendance/final_attendance.dart';
import 'package:portal/Faculty/Faculty_Home/Faculty_Activities/Mark_Attendance/specific_student_attendance.dart';
class MarkAttendanceScreen extends StatefulWidget {
  final String teacherId;
  const MarkAttendanceScreen({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final DatabaseReference _ref = FirebaseDatabase.instance.reference();
  final ref = FirebaseDatabase.instance.ref("Classroom");
  final searchController = TextEditingController();
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
        assignedClasses = assignedClass["class"];
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
          if (assignedClasses == null)
            const Center(
              child: Text(
                "No classes assigned to this teacher",
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  final assignedClass = assignedClasses;
                  final section = sections;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MarkAttendance(class_name: assignedClass.toString(), section: section.toString(),)));
                          });
                        },
                        child: Text("Mark Attendance"),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (assignedClasses != null && sections != null)
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search Student",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: FirebaseAnimatedList(
                      query: ref.child(assignedClasses!).child(sections!),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        String rollNumber = snapshot.key ?? 'No Roll Number';
                        String studentName = snapshot.child('name').value as String? ?? 'Not filled yet';
                        if (searchController.text.isEmpty ||
                            rollNumber.toLowerCase().contains(searchController.text.toLowerCase()) ||
                            studentName.toLowerCase().contains(searchController.text.toLowerCase())) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(studentName),
                              subtitle: Text(rollNumber),
                              trailing: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SpecificStudentAttendanceScreen(roll_no: rollNumber, class_name: assignedClasses.toString(), section: sections.toString())));
                                  });
                                },
                                  child: Icon(Icons.navigate_next)),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
