import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    // color: Colors.black87,
                    color: Colors.white,
                    blurRadius: 10,
                  )
                ],
              ),
              child: DataTable(
                columns: const [
                DataColumn(label: Text("Subject",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                DataColumn(label: Text("Attendance %",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)))
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("Linear Algebra")),
                    DataCell(Text("79%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Design and Analysis of Algorithm")),
                    DataCell(Text("82%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Communication and presentation skills")),
                    DataCell(Text("99%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Database")),
                    DataCell(Text("87%")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Operating System")),
                    DataCell(Text("100%")),
                  ])
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
