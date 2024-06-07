import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class StudentGradesScreen extends StatefulWidget {
  final String classs;
  final String section;
  final String roll_no;
  final String name;
  const StudentGradesScreen({Key? key, required this.classs, required this.section, required this.roll_no, required this.name}) : super(key: key);

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, Map<String, dynamic>> _grades = {};
  List<String> _subjects = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch subjects
      DataSnapshot subjectsSnapshot = await _database
          .child('Subjects')
          .child(widget.classs)
          .child(widget.section)
          .get();

      List<String> subjects = [];
      if (subjectsSnapshot.value != null) {
        subjects = List<String>.from(subjectsSnapshot.value as List);
      }

      // Fetch grades
      DataSnapshot gradesSnapshot = await _database
          .child('Classroom')
          .child(widget.classs)
          .child(widget.section)
          .child(widget.roll_no)
          .child('Exam')
          .get();

      Map<String, dynamic> examData = {};
      if (gradesSnapshot.value != null) {
        examData = Map<String, dynamic>.from(gradesSnapshot.value as Map);
      }

      setState(() {
        _subjects = subjects;
        _grades = _processGrades(examData, subjects);
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $error')),
      );
    }
  }

  Map<String, Map<String, dynamic>> _processGrades(Map<String, dynamic> data, List<String> subjects) {
    Map<String, Map<String, dynamic>> processedData = {};
    for (var term in ['First Term', 'Second Term', 'Third Term', 'Final Term']) {
      if (data.containsKey(term)) {
        Map<String, dynamic> subjectsData = Map<String, dynamic>.from(data[term]);
        Map<String, dynamic> completeSubjectsData = {};
        for (var subject in subjects) {
          completeSubjectsData[subject] = {
            'marks': subjectsData.containsKey(subject) ? subjectsData[subject]['marks'] : '0'
          };
        }
        processedData[term] = completeSubjectsData;
      }
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
              // School Name
              pw.Center(
                child: pw.Text(
                  "The City School",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#4A90E2"),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              // Student Info Table
              pw.Table.fromTextArray(
                cellAlignment: pw.Alignment.centerLeft,
                headerAlignment: pw.Alignment.centerLeft,
                data: [
                  ['Name:', widget.name],
                  ['Roll No:', widget.roll_no],
                  ['Class:', widget.classs],
                  ['Section:', widget.section],
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  "Marks Distribution",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              // Grades Table with Bold Headers
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex("#E0E0E0")),
                    children: _buildTableHeaders().map((header) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          header,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                  ..._buildTableData().map((row) {
                    return pw.TableRow(
                      children: row.map((cell) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            cell,
                            textAlign: pw.TextAlign.center,
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ],
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission is required to generate PDF.')));
    }
  }

  List<String> _buildTableHeaders() {
    return ['Subject', 'First Term', 'Second Term', 'Third Term', 'Final Term'];
  }

  List<List<String>> _buildTableData() {
    List<List<String>> data = [];

    _subjects.forEach((subject) {
      List<String> row = [subject];
      row.add(_grades['First Term']?[subject]?['marks']?.toString() ?? '0');
      row.add(_grades['Second Term']?[subject]?['marks']?.toString() ?? '0');
      row.add(_grades['Third Term']?[subject]?['marks']?.toString() ?? '0');
      row.add(_grades['Final Term']?[subject]?['marks']?.toString() ?? '0');
      data.add(row);
    });

    return data;
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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _grades.length,
        itemBuilder: (context, index) {
          String term = ['First Term', 'Second Term', 'Third Term', 'Final Term'][index];
          Map<String, dynamic> subjects = _grades[term]!;
          return Card(
            color: Colors.blueGrey.shade100,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ExpansionTile(
              title: Text(
                term,
                style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.bold),
              ),
              children: _subjects.map((subject) {
                String marks = subjects[subject]?['marks']?.toString() ?? '0';
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
        child: const Icon(Icons.download),
      ),
    );
  }
}
