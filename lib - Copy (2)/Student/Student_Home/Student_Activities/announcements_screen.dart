import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal/Student/Student_Home/Student_Activities/messages_from_admin.dart';
import 'package:portal/Student/Student_Home/Student_Activities/messages_from_teachers.dart';

class AnnouncementsScreen extends StatefulWidget {
  final String class_name;
  final String class_section;
  const AnnouncementsScreen({super.key, required this.class_name, required this.class_section});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Announcements");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, // Change this color to whatever you want
            ),
            backgroundColor: Colors.transparent,
            title: const Text("Announcements", style: TextStyle(color: Colors.white)),
            bottom: const TabBar(
              tabs: [
                Icon(Icons.person, color: Colors.white, size: 30),
                Icon(Icons.man_2, color: Colors.white, size: 30),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MessagesFromAdmin(),
              MessagesFromTeachers(class_name: widget.class_name, class_section: widget.class_section)
            ],
          ),
          backgroundColor: Colors.blueGrey.shade700,
        ),
    );
  }
}
