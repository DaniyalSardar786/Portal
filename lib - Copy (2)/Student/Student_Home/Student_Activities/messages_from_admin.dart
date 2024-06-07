import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesFromAdmin extends StatefulWidget {
  const MessagesFromAdmin({super.key});

  @override
  State<MessagesFromAdmin> createState() => _MessagesFromAdminState();
}

class _MessagesFromAdminState extends State<MessagesFromAdmin> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Announcements");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ListView at the top
        Expanded(
          child:  StreamBuilder(
            stream: ref.onValue, // Stream of data from Firebase
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData && !snapshot.hasError) {
                // Data received successfully
                Map<dynamic, dynamic>? announcementsData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                if (announcementsData != null) {
                  List<Widget> announcementWidgets = [];

                  // Iterate over the announcements data and filter those sent by the admin
                  announcementsData.forEach((key, value) {
                    // Assuming 'sender' is the key for the sender of the announcement
                    String sender = value['sender'];
                    if (sender == 'Admin') {
                      // Display only the announcements sent by the admin
                      String announcement = value['announcement'];
                      int timestamp = value['timestamp']; // Extract timestamp from Firebase
                      String formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp)); // Format timestamp
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

                            title: Text(announcement,style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                            subtitle: Text("\nSent by Admin - $formattedDate",style:  TextStyle(color: Colors.grey.shade700),), // Display formatted date
                          ),
                        ),
                      );
                    }
                  });

                  return ListView(
                    children: announcementWidgets,
                  );
                } else {
                  // Handle case where there are no announcements
                  return Center(
                    child: Text("No announcements"),
                  );
                }
              } else {
                // Handle error case
                return Center(
                  child: Text("Error fetching announcements"),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
