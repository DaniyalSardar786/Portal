import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesFromTeachers extends StatefulWidget {
  final String class_name;
  final String class_section;
  const MessagesFromTeachers({super.key, required this.class_name, required this.class_section});

  @override
  State<MessagesFromTeachers> createState() => _MessagesFromTeachersState();
}

class _MessagesFromTeachersState extends State<MessagesFromTeachers> {
  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    // Create a reference to the specific node based on class and section
    ref = FirebaseDatabase.instance.ref("Teachers Announcements/${widget.class_name}/${widget.class_section}");
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
          "Messages From Teachers",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && !snapshot.hasError) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            if (dataSnapshot.value == null) {
              return Center(
                child: Text("No messages"),
              );
            }

            Map<dynamic, dynamic>? messagesData = dataSnapshot.value as Map<dynamic, dynamic>?;

            if (messagesData != null) {
              List<Widget> messageWidgets = [];

              messagesData.forEach((key, value) {
                if (value != null) {
                  String message = value['announcement'] ?? 'No message content';
                  String sender=value['sender']??'No name';
                  int timestamp = value['timestamp'] ?? 0;
                  String formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp));
                  messageWidgets.add(
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          message,
                        ),
                        subtitle: Text("$sender || $formattedDate",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  );
                }
              });

              return ListView(
                children: messageWidgets,
              );
            } else {
              return Center(
                child: Text("No messages"),
              );
            }
          } else {
            return Center(
              child: Text("Error fetching messages"),
            );
          }
        },
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
