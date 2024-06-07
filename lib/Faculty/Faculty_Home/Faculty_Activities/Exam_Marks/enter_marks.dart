import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:portal/Others/elevated_button.dart';

class EnterMarksScreen extends StatefulWidget {
  final String classs;
  final String section;
  final String subject;
  final String exam;
  final String roll_no;
  const EnterMarksScreen({
    super.key,
    required this.classs,
    required this.section,
    required this.subject,
    required this.exam,
    required this.roll_no
  });

  @override
  State<EnterMarksScreen> createState() => _EnterMarksScreenState();
}

class _EnterMarksScreenState extends State<EnterMarksScreen> {
  final _formKey = GlobalKey<FormState>();
  final _marksController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingMarks();
  }

  void _loadExistingMarks() async {
    setState(() {
      loading = true;
    });

    DatabaseEvent event = await _database
        .child('Classroom')
        .child(widget.classs)
        .child(widget.section)
        .child(widget.roll_no)
        .child('Exam')
        .child(widget.exam)
        .child(widget.subject)
        .once();

    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      String marks = data['marks'] ?? '';
      _marksController.text = marks;
    }

    setState(() {
      loading = false;
    });
  }

  void _saveMarks() {
    if (_formKey.currentState!.validate()) {
      String marks = _marksController.text;

      _database.child('Classroom')
          .child(widget.classs)
          .child(widget.section)
          .child(widget.roll_no)
          .child('Exam').child(widget.exam).child(widget.subject)
          .update({
        'subject': widget.subject,
        'exam': widget.exam,
        'marks': marks,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Marks saved successfully!'))
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save marks.'))
        );
      });
    }
  }

  @override
  void dispose() {
    _marksController.dispose();
    super.dispose();
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
          "Enter Marks",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, blurRadius: 5)
                  ]),
              child: Column(
                children: [
                  TextFormField(
                    controller: _marksController,
                    decoration: InputDecoration(
                      labelText: "Enter ${widget.exam} marks of ${widget.subject}",
                      labelStyle: const TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter marks';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomizedElevatedButton(
                    text: "Save Marks",
                    onTap: _saveMarks,
                    loading: loading,
                  )
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
