import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

import 'package:intl/intl.dart'; // Import the intl package for date formatting

class AdminAnnouncementScreen extends StatefulWidget {
  const AdminAnnouncementScreen({super.key});

  @override
  State<AdminAnnouncementScreen> createState() => _AdminAnnouncementScreenState();
}

class _AdminAnnouncementScreenState extends State<AdminAnnouncementScreen> {
  bool loading = false;
  TextEditingController announcementController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref("Announcements"); // Reference to Firebase database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
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
                              borderRadius:  BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(announcement,style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.black)),
                              subtitle: Text("\nSent by Admin - $formattedDate",style:  TextStyle(color: Colors.grey.shade700)), // Display formatted date
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
                            loading = true; // Set loading to true to show loading indicator
                          });

                          if(announcementController.text.isNotEmpty){
                            // Save the announcement to Firebase
                            ref.push().set({
                              "announcement": announcementController.text,
                              "sender": "Admin", // Set the sender as Admin
                              "timestamp": DateTime.now().millisecondsSinceEpoch,
                            }).then((_) {
                              // Clear the text field after saving
                              announcementController.clear();

                              // Show a snackbar or toast to indicate successful save
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Announcement saved!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }).catchError((error) {
                              // Handle error if any
                              print('Error saving announcement: $error');
                            }).whenComplete(() {
                              // Set loading to false after completion
                              setState(() {
                                loading = false;
                              });
                            });
                          } else {
                            setState(() {
                              print("Empty announcement");
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
