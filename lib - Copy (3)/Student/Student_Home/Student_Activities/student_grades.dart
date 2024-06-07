import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class StudentGradesScreen extends StatefulWidget {
  final String classs;
  final String section;
  final String roll_no;
  const StudentGradesScreen({Key? key, required this.classs, required this.section, required this.roll_no}) : super(key: key);

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, Map<String, dynamic>> _grades = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    try {
      DataSnapshot snapshot = await _database
          .child('Classroom')
          .child(widget.classs)
          .child(widget.section)
          .child(widget.roll_no)
          .child('Exam')
          .get();

      Map<String, dynamic> examData = {};
      if (snapshot.value != null) {
        examData = Map<String, dynamic>.from(snapshot.value as Map);
      }

      setState(() {
        _grades = _processGrades(examData);
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load grades: $error')),
      );
    }
  }

  Map<String, Map<String, dynamic>> _processGrades(Map<String, dynamic> data) {
    Map<String, Map<String, dynamic>> processedData = {};
    for (var exam in data.keys) {
      Map<String, dynamic> subjects = Map<String, dynamic>.from(data[exam]);
      processedData[exam] = subjects;
    }
    return processedData;
  }

  Future<void> _generatePDF() async {


    final PermissionStatus status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      final pdf = pw.Document();

      // Add data to PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Grades Report",
                style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Exam', 'Subject', 'Marks'],
                data: _grades.entries.expand((entry) {
                  final String exam = entry.key;
                  final Map<String, dynamic> subjects = entry.value;
                  return subjects.entries.map((subjectEntry) {
                    final String subject = subjectEntry.key;
                    final String marks = subjectEntry.value['marks']?.toString() ?? '0';
                    return [exam, subject, marks];
                  });
                }).toList(),
              ),
            ],
          ),
        ),
      );

      final output = await getExternalStorageDirectory();
      final file = File("${output?.path}/grades_report.pdf");
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Storage permission is required to generate PDF.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Grades",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _grades.length,
        itemBuilder: (context, index) {
          String exam = _grades.keys.elementAt(index);
          Map<String, dynamic> subjects = _grades[exam]!;
          return Card(
            color: Colors.blueGrey.shade100,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ExpansionTile(
              title: Text(
                exam,
                style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.bold),
              ),
              children: subjects.keys.map((subject) {
                String marks = subjects[subject]['marks']?.toString() ?? '0';
                return ListTile(
                  title: Text(subject, style: TextStyle(color: Colors.blueGrey.shade700)),
                  trailing: Text(marks, style: TextStyle(color: Colors.blueGrey.shade700)),
                );
              }).toList(),
            ),
          );
        },
      ),
      backgroundColor: Colors.blueGrey.shade700,
      floatingActionButton: FloatingActionButton(
        onPressed: _generatePDF,
        child: Icon(Icons.download),
      ),
    );
  }
}
