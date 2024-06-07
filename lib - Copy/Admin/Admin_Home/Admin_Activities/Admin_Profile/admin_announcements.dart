import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class AdminAnnouncementScreen extends StatefulWidget {
  const AdminAnnouncementScreen({super.key});

  @override
  State<AdminAnnouncementScreen> createState() => _AdminAnnouncementScreenState();
}

class _AdminAnnouncementScreenState extends State<AdminAnnouncementScreen> {
  bool loading = false;
  TextEditingController announcementController = TextEditingController();


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
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child:  ListTile(
                    title: Text("Announcement ${index + 1}"),
                    subtitle: Text("Daaman scene"),
                  ),
                );
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
                        text: "Save",
                        loading: loading,
                        onTap: () {
                          setState(() {
                            loading = true; // Set loading to true to show loading indicator
                          });

                          if(announcementController.text.isNotEmpty){
                            final ref = FirebaseDatabase.instance.ref("Announcements");
                            ref.push().set({
                              "announcement": announcementController.text,
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
                          }else{
                            setState(() {
                              print("Empty ha bawa");
                              loading=false;
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
