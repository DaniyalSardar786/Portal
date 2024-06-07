import 'package:flutter/material.dart';
import 'package:portal/Faculty/Faculty_Home/Faculty_Activities/Exam_Marks/manage_marks.dart';

class SelectExamScreen extends StatefulWidget {
  final String teacherId;
  const SelectExamScreen({super.key, required this.teacherId});

  @override
  State<SelectExamScreen> createState() => _SelectExamScreenState();
}

class _SelectExamScreenState extends State<SelectExamScreen> {
  String? selectedExam;

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
          "Select Exam",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 5
                  )
                ]
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Term",
                      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      // fillColor: Colors.blueGrey.shade200,
                    ),
                    dropdownColor: Colors.blueGrey.shade100,
                    value: selectedExam,
                    items: <String>[
                      'First Term',
                      'Second Term',
                      'Third Term',
                      'Final Term'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedExam = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a term' : null,
                    style: TextStyle(color: Colors.white),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedExam != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageMarksScreen(selectedExam: selectedExam!, teacherId: widget.teacherId,),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an exam term'),
                          ),
                        );
                      }
                    },
                    child: const Text("Next"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}