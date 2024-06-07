import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Others/elevated_button.dart';

class MakeAnnouncementToClass extends StatefulWidget {
  final String class_name;
  final String section_name;
  final String teacher_id;
  const MakeAnnouncementToClass({Key? key, required this.class_name, required this.section_name, required this.teacher_id}) : super(key: key);

  @override
  State<MakeAnnouncementToClass> createState() => _MakeAnnouncementToClassState();
}

class _MakeAnnouncementToClassState extends State<MakeAnnouncementToClass> {
  bool loading = false;
  TextEditingController announcementController = TextEditingController();

  late DatabaseReference ref;
  final teacherRef = FirebaseDatabase.instance.ref("Teachers");
  String? teacherName;
  Map<String, dynamic>? teacherData;

  @override
  void initState() {
    super.initState();
    // Create a reference to the specific node based on class and section
    ref = FirebaseDatabase.instance.ref("Teachers Announcements/${widget.class_name}/${widget.section_name}");
    fetchTeacherData();
  }

  void fetchTeacherData() async {
    final snapshot = await teacherRef.child(widget.teacher_id).get();

    if (snapshot.exists) {
      setState(() {
        teacherData = Map<String, dynamic>.from(snapshot.value as Map);
        teacherName = teacherData?["name"] ?? '';
      });
    } else {
      setState(() {
        teacherData = null;
      });
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
          "Announcements",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // ListView at the top
          Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && !snapshot.hasError) {
                  Map<dynamic, dynamic>? announcementsData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                  if (announcementsData != null) {
                    List<Widget> announcementWidgets = [];

                    announcementsData.forEach((key, value) {
                      String announcement = value['announcement'];
                      int timestamp = value['timestamp'];
                      String formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp));
                      announcementWidgets.add(
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
                              announcement,
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            subtitle: Text(
                              "\nSent by ${value['sender']} - $formattedDate",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text("Are you sure you want to delete this announcement?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ref.child(key).remove();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    });

                    return ListView(
                      children: announcementWidgets,
                    );
                  } else {
                    return Center(
                      child: Text("No announcements"),
                    );
                  }
                } else {
                  return Center(
                    child: Text("Error fetching announcements"),
                  );
                }
              },
            ),
          ),
          // Container at the bottom
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: announcementController,
                  decoration: InputDecoration(
                    labelText: 'Make Announcement',
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.announcement),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomizedElevatedButton(
                        text: "Send",
                        loading: loading,
                        onTap: () {
                          setState(() {
                            loading = true;
                          });

                          if (announcementController.text.isNotEmpty) {
                            ref.push().set({
                              "announcement": announcementController.text,
                              "sender": teacherName ?? "Admin",
                              "timestamp": DateTime.now().millisecondsSinceEpoch,
                            }).then((_) {
                              announcementController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Announcement saved!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }).catchError((error) {
                              print('Error saving announcement: $error');
                            }).whenComplete(() {
                              setState(() {
                                loading = false;
                              });
                            });
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
