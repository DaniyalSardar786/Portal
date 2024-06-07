import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddTeacherSubjectScreen extends StatefulWidget {
  final String classs_name;
  final String subject_name;
  final String section;
  const AddTeacherSubjectScreen({super.key, required this.classs_name, required this.subject_name, required this.section});

  @override
  State<AddTeacherSubjectScreen> createState() => _AddTeacherSubjectScreenState();
}

class _AddTeacherSubjectScreenState extends State<AddTeacherSubjectScreen> {
  final ref = FirebaseDatabase.instance.ref("Teachers");
  String? selectedTeacher;
  List<String> teacherNames = [];
  List<String> teacherIds = [];

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    final snapshot = await ref.get();
    final List<dynamic>? teachersList = snapshot.value as List<dynamic>?;

    if (teachersList != null && teachersList.isNotEmpty) {
      teachersList.forEach((teacher) {
        if (teacher != null && teacher is Map<dynamic, dynamic>) {
          final teacherName = teacher['name']?.toString();
          final teacherId = teacher['id']?.toString(); // Assuming 'id' is the key for teacher ID
          if (teacherName != null && teacherId != null) {
            teacherNames.add(teacherName);
            teacherIds.add(teacherId);
          }
        }
      });
      setState(() {});
    }
  }



  Future<String?> isSubjectAlreadyAssigned() async {
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final teachersList = snapshot.value as List<dynamic>?;

      print('Teachers List Type: ${teachersList.runtimeType}');
      // Add this print statement to see the type of teachersList

      if (teachersList != null) {
        for (var teacher in teachersList) {
          if (teacher is Map<dynamic, dynamic>) {
            final assignments = teacher['assignments'];
            if (assignments is Map<dynamic, dynamic>) {
              // If assignments is a map, check if it's not empty and then iterate over it
              if (assignments.isNotEmpty) {
                for (var assignmentKey in assignments.keys) {
                  final assignment = assignments[assignmentKey];
                  if (assignment is Map<dynamic, dynamic> &&
                      assignment['class'] == widget.classs_name &&
                      assignment['section'] == widget.section &&
                      assignment['subject'] == widget.subject_name) {
                    return teacher['id'];
                  }
                }
              }
            } else if (assignments is List) {
              // If assignments is a list, you might need to handle it differently based on your data structure
              // For now, I'll return null as you might need to adjust this part according to your data structure
              return null;
            }
          }
        }
      }
    }
    return null;
  }


  void assignSubjectToTeacher() async {
    if (selectedTeacher != null) {
      final previousTeacherId = await isSubjectAlreadyAssigned();
      if (previousTeacherId != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Reassign Subject'),
              content: Text('This subject is already assigned to another teacher. Do you want to reassign it?'),
              actions: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final teacherIndex = teacherNames.indexOf(selectedTeacher!.split(' - ')[0]);
                    final teacherId = teacherIds[teacherIndex];
                    final assignmentKey = '${widget.classs_name}_${widget.section}_${widget.subject_name}';

                    // Remove the assignment from the previous teacher
                    await ref.child('$previousTeacherId/assignments/$assignmentKey').remove();

                    // Assign the subject to the new teacher
                    await ref.child('$teacherId/assignments/$assignmentKey').set({
                      'class': widget.classs_name,
                      'section': widget.section,
                      'subject': widget.subject_name,
                    }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Subject reassigned to ${selectedTeacher!.split(' - ')[0]}'),
                      ));
                    });
                  },
                ),
              ],
            );
          },
        );
      } else {
        final teacherIndex = teacherNames.indexOf(selectedTeacher!.split(' - ')[0]);
        final teacherId = teacherIds[teacherIndex];
        final assignmentKey = '${widget.classs_name}_${widget.section}_${widget.subject_name}';

        await ref.child('$teacherId/assignments/$assignmentKey').set({
          'class': widget.classs_name,
          'section': widget.section,
          'subject': widget.subject_name,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Subject assigned to ${selectedTeacher!.split(' - ')[0]}'),
          ));
        });
      }
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
          "Assign Subject",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10
                )
              ]
            ),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Teacher",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedTeacher,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTeacher = newValue;
                    });
                  },
                  items: teacherNames.asMap().entries.map<DropdownMenuItem<String>>((entry) {
                    int idx = entry.key;
                    String name = entry.value;
                    String id = teacherIds[idx];
                    return DropdownMenuItem<String>(
                      value: '$name - $id',
                      child: Text('$name - $id'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: assignSubjectToTeacher,
                  child: Text('Assign Subject'),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
