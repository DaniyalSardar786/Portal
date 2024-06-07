import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/edit_class.dart';

class ManageClassesScreen extends StatefulWidget {
  const ManageClassesScreen({Key? key}) : super(key: key);

  @override
  State<ManageClassesScreen> createState() => _ManageClassesScreenState();
}

class _ManageClassesScreenState extends State<ManageClassesScreen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Classroom");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Manage Classes", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: ref.once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Display circular progress indicator
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text('No data available'),
            );
          }
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          return FirebaseAnimatedList(
            query: ref,
            itemBuilder: (context, classSnapshot, classAnimation, classIndex) {
              String className = classSnapshot.key ?? 'No Class Name';
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Class: $className",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: ref.child(className),
                      itemBuilder: (context, sectionSnapshot, sectionAnimation, sectionIndex) {
                        String sectionName = sectionSnapshot.key ?? 'No Section Name';

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text("Section: $sectionName"),
                            trailing: InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditClassScreen(
                                      classs: className,
                                      section: sectionName,
                                    ),
                                  ),
                                );
                                // Refresh the screen when the user returns from the edit screen
                                setState(() {});
                              },
                              child: const Icon(Icons.edit),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
