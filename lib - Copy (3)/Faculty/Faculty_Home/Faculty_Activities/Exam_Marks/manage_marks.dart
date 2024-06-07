import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Faculty/Faculty_Home/Faculty_Activities/Exam_Marks/class_students.dart';

class ManageMarksScreen extends StatefulWidget {
  final String teacherId;
  final String selectedExam;
  const ManageMarksScreen(
      {super.key, required this.teacherId, required this.selectedExam});

  @override
  State<ManageMarksScreen> createState() => _ManageMarksScreenState();
}

class _ManageMarksScreenState extends State<ManageMarksScreen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Teachers");
  List<Map<String, String>> assignments = [];

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    final snapshot = await ref.child('${widget.teacherId}/assignments').get();
    if (snapshot.exists) {
      final assignmentsMap = snapshot.value as Map<dynamic, dynamic>;
      assignments = (assignmentsMap.keys as Iterable<dynamic>)
          .map<Map<String, String>>((key) {
        final assignment = assignmentsMap[key];
        return {
          'key': key,
          'class': assignment['class'] as String,
          'section': assignment['section'] as String,
          'subject': assignment['subject'] as String,
        };
      }).toList();
      setState(() {});
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
          "Manage Marks",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: assignments.isEmpty
          ? const Center(
              child: Text('No classes assigned to this teacher',
                  style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassStudentsScreen(
                                    teacherId: widget.teacherId,
                                    classs: assignment["class"].toString(),
                                    section: assignment["section"].toString(),
                                    subject: assignment['subject'].toString(),
                                exam: widget.selectedExam,
                                  )));
                    },
                    title: Text('Subject: ${assignment['subject']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(
                        'Class: ${assignment["class"]}${assignment["section"]}',
                        style: const TextStyle(color: Colors.black)),
                    trailing: const Icon(Icons.edit),
                  ),
                );
              },
            ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
