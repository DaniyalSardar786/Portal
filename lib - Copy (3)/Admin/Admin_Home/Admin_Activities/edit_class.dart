import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/add_subjects_tecahers.dart';

class Subject {
  String name;
  bool isSelected;

  Subject(this.name, this.isSelected);
}

class EditClassScreen extends StatefulWidget {
  final String classs;
  final String section;
  const EditClassScreen({super.key, required this.classs, required this.section});

  @override
  State<EditClassScreen> createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final ref = FirebaseDatabase.instance.ref("Classroom");
  final reference = FirebaseDatabase.instance.ref("Subjects");
  final searchController = TextEditingController();

  String? classTeacherid;
  final refTeacher = FirebaseDatabase.instance.ref("Teachers");
  String? selectedTeacher;
  List<String> teacherNames = [];
  List<String> teacherIds = [];

  @override
  void initState() {
    super.initState();
    fetchTeachers();
    checkClassTeacher(widget.classs, widget.section);
  }

  Future<void> fetchTeachers() async {
    final snapshot = await refTeacher.get();
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

  final bool loading = false;
  String? selectedSubject;

  final databaseReference = FirebaseDatabase.instance.reference();
  List<Subject> subjects = [
    Subject("Math", false),
    Subject("English", false),
    Subject("Science", false),
    Subject("Social Studies", false),
    Subject("History", false),
    Subject("Computer Science", false),
    Subject("Biology", false),
    Subject("Chemistry", false),
    Subject("Physics", false),
    Subject("Urdu", false),
    Subject("Geography", false),
    Subject("Arabic", false),
    Subject("Naazra", false),
    Subject("Islamic Studies", false),
    Subject("Pakistan Study", false),
    Subject("Economics", false),
    Subject("Psychology", false),
    Subject("Statistics", false),
  ];

  void _saveSubjects() async {
    List<String> selectedSubjects = subjects
        .where((subject) => subject.isSelected)
        .map((subject) => subject.name)
        .toList();

    // Step 1: Retrieve the currently assigned subjects for the specified class and section
    DatabaseReference subjectsRef = databaseReference.child("Subjects").child(widget.classs).child(widget.section);
    DatabaseEvent subjectsEvent = await subjectsRef.once();
    DataSnapshot subjectsSnapshot = subjectsEvent.snapshot;

    List<String> previouslyAssignedSubjects = [];
    if (subjectsSnapshot.value != null) {
      if (subjectsSnapshot.value is List<dynamic>) {
        previouslyAssignedSubjects = List<String>.from(subjectsSnapshot.value as List<dynamic>);
      } else if (subjectsSnapshot.value is Map<dynamic, dynamic>) {
        previouslyAssignedSubjects = (subjectsSnapshot.value as Map<dynamic, dynamic>).values.cast<String>().toList();
      }
    }

    // Step 2: Compare the currently assigned subjects with the newly selected subjects
    List<String> subjectsToRemove = previouslyAssignedSubjects.where((subject) => !selectedSubjects.contains(subject)).toList();

    // Step 3: Remove subjects from teacher assignments that are not in the newly selected subjects list
    final ref = FirebaseDatabase.instance.ref("Teachers");
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> teachersMap = snapshot.value as Map<dynamic, dynamic>;

        for (var entry in teachersMap.entries) {
          var teacherId = entry.key;
          var teacherData = entry.value;

          if (teacherData['assignments'] != null) {
            Map<dynamic, dynamic> assignments = teacherData['assignments'];

            for (String subjectToRemove in subjectsToRemove) {
              String assignmentKey = '${widget.classs}_${widget.section}_$subjectToRemove';
              if (assignments.containsKey(assignmentKey)) {
                await ref.child(teacherId).child('assignments').child(assignmentKey).remove();
              }
            }
          }
        }
      } else if (snapshot.value is List<dynamic>) {
        List<dynamic> teachersList = snapshot.value as List<dynamic>;

        for (var i = 0; i < teachersList.length; i++) {
          var teacherData = teachersList[i];

          if (teacherData != null && teacherData['assignments'] != null) {
            Map<dynamic, dynamic> assignments = teacherData['assignments'];

            for (String subjectToRemove in subjectsToRemove) {
              String assignmentKey = '${widget.classs}_${widget.section}_$subjectToRemove';
              if (assignments.containsKey(assignmentKey)) {
                await ref.child(i.toString()).child('assignments').child(assignmentKey).remove();
              }
            }
          }
        }
      } else {
        print('Unexpected data format.');
      }
    } else {
      print('No teachers found in the database.');
    }

    // Step 4: Save the newly selected subjects
    await subjectsRef.set(selectedSubjects);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Subjects updated successfully')),
    );
  }

  void deleteStudent(String classs, String section, String rollNumber) {
    ref.child(classs).child(section).child(rollNumber).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student $rollNumber deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student: $error')),
      );
    });
  }

  Future<void> assignClassTeacher() async {
    final ref = FirebaseDatabase.instance.ref("Teachers");

    try {
      // Fetch all teachers from the database
      DatabaseEvent event = await ref.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        if (snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> teachersMap = snapshot.value as Map<dynamic, dynamic>;

          for (var entry in teachersMap.entries) {
            var teacherId = entry.key;
            var teacherData = entry.value;

            if (teacherData['assignedClass'] != null &&
                teacherData['assignedClass']['class'] == widget.classs &&
                teacherData['assignedClass']['section'] == widget.section) {
              // Remove the previous assignment
              await ref.child(teacherId).child('assignedClass').remove();
            }
          }
        } else if (snapshot.value is List<dynamic>) {
          List<dynamic> teachersList = snapshot.value as List<dynamic>;

          for (var i = 0; i < teachersList.length; i++) {
            var teacherData = teachersList[i];

            if (teacherData != null &&
                teacherData['assignedClass'] != null &&
                teacherData['assignedClass']['class'] == widget.classs &&
                teacherData['assignedClass']['section'] == widget.section) {
              // Remove the previous assignment
              await ref.child(i.toString()).child('assignedClass').remove();
            }
          }
        } else {
          print('Unexpected data format.');
        }
      } else {
        print('No teachers found in the database.');
      }
    } catch (e) {
      print('An error occurred while fetching the teacher data: $e');
    }

    if (selectedTeacher != null) {
      final teacherId = selectedTeacher!.split(' - ').last;

      // Assign the new teacher to the class and section
      await ref.child(teacherId).child('assignedClass').set({
        'class': widget.classs,
        'section': widget.section,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class teacher assigned successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a teacher')),
      );
    }
  }

  String? classTeacherName;
  int? classTeacherId;

  Future<void> checkClassTeacher(String desiredClass, String desiredSection) async {
    final ref = FirebaseDatabase.instance.ref("Teachers");
    List<Map<String, dynamic>> matchingTeachers = [];

    try {
      // Fetch all teachers from the database
      DatabaseEvent event = await ref.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        // Check if the data is a list or a map
        if (snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> teachersMap = snapshot.value as Map<dynamic, dynamic>;

          for (var entry in teachersMap.entries) {
            var teacherId = entry.key;
            var teacherData = entry.value;

            if (teacherData['assignedClass'] != null &&
                teacherData['assignedClass']['class'] == desiredClass &&
                teacherData['assignedClass']['section'] == desiredSection) {
              // Store the teacher details in a list
              matchingTeachers.add({
                'id': teacherId,
                'name': teacherData['name'],
                'class': teacherData['assignedClass']['class'],
                'section': teacherData['assignedClass']['section'],
                // Add more fields as required
              });
            }
          }
        } else if (snapshot.value is List<dynamic>) {
          List<dynamic> teachersList = snapshot.value as List<dynamic>;

          for (var i = 0; i < teachersList.length; i++) {
            var teacherData = teachersList[i];

            if (teacherData != null &&
                teacherData['assignedClass'] != null &&
                teacherData['assignedClass']['class'] == desiredClass &&
                teacherData['assignedClass']['section'] == desiredSection) {
              // Store the teacher details in a list
              matchingTeachers.add({
                'id': i, // Using the index as the ID
                'name': teacherData['name'],
                'class': teacherData['assignedClass']['class'],
                'section': teacherData['assignedClass']['section'],
                // Add more fields as required
              });
            }
          }
        } else {
          print('Unexpected data format.');
        }

        // Print the details of the matching teachers
        for (var teacher in matchingTeachers) {
          classTeacherId = teacher['id'];
          classTeacherName = teacher['name'];
        }
      } else {
        print('No teachers found in the database.');
      }
    } catch (e) {
      print('An error occurred while fetching the teacher data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this color to whatever you want
          ),
          backgroundColor: Colors.transparent,
          title: Text("${widget.classs} ${widget.section}", style: TextStyle(color: Colors.white)),
          bottom: const TabBar(
            tabs: [
              Icon(Icons.menu_book, color: Colors.white, size: 30),
              Icon(Icons.perm_identity, color: Colors.white, size: 30),
              Icon(Icons.man, color: Colors.white, size: 30),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Add Subject",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text("Select Subjects"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: subjects
                                            .map((subject) => CheckboxListTile(
                                          title: Text(subject.name),
                                          value: subject.isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              subject.isSelected = value!;
                                            });
                                          },
                                        ))
                                            .toList(),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _saveSubjects();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Save"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text("Select Subjects"),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: FirebaseAnimatedList(
                    query: reference.child(widget.classs).child(widget.section), // Corrected reference
                    itemBuilder: (context, snapshot, animation, index) {
                      // Extract the subject from the snapshot
                      Object? subject = snapshot.value;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text("$subject"),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTeacherSubjectScreen(
                                    subject_name: subject.toString(),
                                    classs_name: widget.classs,
                                    section: widget.section,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    query: ref.child(widget.classs).child(widget.section),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      String rollNumber = snapshot.key ?? 'No Roll Number';
                      String studentName = snapshot.child('name').value as String? ?? 'Not filled yet';
                      if (searchController.text.isEmpty ||
                          rollNumber.toLowerCase().contains(searchController.text.toLowerCase()) ||
                          studentName.toLowerCase().contains(searchController.text.toLowerCase())) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(studentName),
                            subtitle: Text(rollNumber),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.edit),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Student'),
                                        content: Text('Are you sure you want to delete this student?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      setState(() {
                                        deleteStudent(widget.classs, widget.section, rollNumber);
                                      });
                                    }
                                  },
                                  child: Icon(Icons.delete),
                                ),
                              ],
                            ),
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text("Select Class Teacher", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
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
                              classTeacherid=id;
                              return DropdownMenuItem<String>(
                                value: '$name - $id',
                                child: Text('$name - $id'),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                assignClassTeacher();
                              });
                            },
                            child: Text('Assign Class Teacher'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 10
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Class Teacher ",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      )),
                      Card(
                        child: ListTile(
                          title: Text(classTeacherName??"No one assigned yet!"),
                          subtitle: Text(classTeacherId.toString()),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey.shade700,
      ),
    );
  }

  Widget buildDropdownButtonFormField(String labelText, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        prefixIcon: const Icon(Icons.person),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );

  }
}
