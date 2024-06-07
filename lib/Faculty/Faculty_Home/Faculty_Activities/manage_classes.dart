import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Faculty/Faculty_Home/Faculty_Activities/make_announcement_to_class.dart';

class ManageMyClassesScreen extends StatefulWidget {
  final String teacherId;
  const ManageMyClassesScreen({super.key, required this.teacherId});

  @override
  State<ManageMyClassesScreen> createState() => _ManageMyClassesScreenState();
}

class _ManageMyClassesScreenState extends State<ManageMyClassesScreen> {
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
      assignments = (assignmentsMap.keys as Iterable<dynamic>).map<Map<String, String>>((key) {
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

  Future<void> confirmDeleteAssignment(BuildContext context, String key) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this assignment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmed) {
      deleteAssignment(key);
    }
  }

  Future<void> deleteAssignment(String key) async {
    await ref.child('${widget.teacherId}/assignments/$key').remove();
    setState(() {
      assignments.removeWhere((assignment) => assignment['key'] == key);
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
          "Manage Classes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: assignments.isEmpty
          ? Center(child: Text('No classes assigned to this teacher', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text('Subject: ${assignment['subject']}', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Text('Class: ${assignment["class"]}${assignment["section"]}', style: TextStyle(color: Colors.black)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.message, color: Colors.black54),
                    onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeAnnouncementToClass(teacher_id: widget.teacherId,class_name: assignment["class"].toString(),section_name: assignment["section"].toString(),)));
                    }
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.black54),
                    onPressed: () => confirmDeleteAssignment(context, assignment['key']!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
