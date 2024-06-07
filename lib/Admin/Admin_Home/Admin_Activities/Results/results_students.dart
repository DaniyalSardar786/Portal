import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:portal/Student/Student_Home/Student_Activities/student_grades.dart';

class ResultsStudentsScreen extends StatefulWidget {
  final String classs;
  final String section;
  const ResultsStudentsScreen({super.key, required this.classs, required this.section});

  @override
  State<ResultsStudentsScreen> createState() => _ResultsStudentsScreenState();
}

class _ResultsStudentsScreenState extends State<ResultsStudentsScreen> {
  final searchController=TextEditingController();
  final ref=FirebaseDatabase.instance.ref("Classroom");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
        ),
        backgroundColor: Colors.transparent,
        title: Text("${widget.classs} ${widget.section}", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentGradesScreen(classs: widget.classs, section: widget.section, roll_no: rollNumber, name: studentName)));
                      },
                      leading: Text(rollNumber,style: TextStyle(fontSize: 16),),
                      title: Text(studentName),

                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.navigate_next),
                          SizedBox(width: 10),
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
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
