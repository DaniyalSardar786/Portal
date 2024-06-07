import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'enter_marks.dart';

class ClassStudentsScreen extends StatefulWidget {
  final String teacherId;
  final String classs;
  final String section;
  final String subject;
  final String exam;
  const ClassStudentsScreen(
      {Key? key,
      required this.teacherId,
      required this.classs,
      required this.section,
      required this.subject, required this.exam})
      : super(key: key);

  @override
  State<ClassStudentsScreen> createState() => _ClassStudentsScreenState();
}

class _ClassStudentsScreenState extends State<ClassStudentsScreen> {
  final ref = FirebaseDatabase.instance.ref("Classroom");
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          "Students",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
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
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                String rollNumber = snapshot.key ?? 'No Roll Number';
                String studentName =
                    snapshot.child('name').value as String? ?? 'Not filled yet';
                if (searchController.text.isEmpty ||
                    rollNumber
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()) ||
                    studentName
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterMarksScreen(
                                      classs: widget.classs,
                                      section: widget.section,
                                      subject: widget.subject,
                                  exam: widget.exam,
                                  roll_no: rollNumber.toString(),
                                    )));
                      },
                      title: Text(studentName),
                      subtitle: Text(rollNumber),
                      trailing: Icon(Icons.navigate_next),
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
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
