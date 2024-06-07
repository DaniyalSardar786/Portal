import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class ManageAccountsScreen extends StatefulWidget {
  const ManageAccountsScreen({super.key});

  @override
  State<ManageAccountsScreen> createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> {

  TextEditingController studentRollNoController=TextEditingController();
  TextEditingController facultyRollNoController=TextEditingController();
  String? selectedClass;
  String? selectedSection;
  bool lockLoading=false;
  bool unlockLoading=false;
  bool unlockAllStudents=false;
  bool lockAllStudents=false;
  bool lockFaculty=false;
  bool unlockFaculty=false;
  bool unlockAllFaculty=false;
  bool lockAllFaculty=false;

  final databaseRef = FirebaseDatabase.instance.ref("Students");

  void changeStatus(String status) async {

    if (selectedClass != null &&
        selectedSection != null &&
        studentRollNoController.text.isNotEmpty) {
      final ref = FirebaseDatabase.instance.ref("Classroom")
          .child(selectedClass!)
          .child(selectedSection!)
          .child(studentRollNoController.text.trim());

      try {
        // Retrieve data from the database
        DataSnapshot snapshot = await ref.once().then((event) {
          return event.snapshot;
                });

        if (snapshot.value != null) {
          // Roll number exists, proceed to update the status
          await ref.update({
            'status': status.toString(),
          });
          showSuccess("Status changed successfully");
        } else {
          // Roll number doesn't exist, show warning
          showError("Roll number does not exist!");
        }
      } catch (error) {
        showError("Failed to change status: $error");
      }

      setState(() {
        unlockLoading = false;
        lockLoading = false;
      });
    } else {
      showError("Please fill all fields!");
    }
  }
  void changeStatusTeacher(String status) async {

    if (facultyRollNoController.text.isNotEmpty) {
      final ref = FirebaseDatabase.instance.ref("Teachers")
          .child(facultyRollNoController.text.trim());

      try {
        // Retrieve data from the database
        DataSnapshot snapshot = await ref.once().then((event) {
          return event.snapshot;
        });

        if (snapshot.value != null) {
          // Roll number exists, proceed to update the status
          await ref.update({
            'status': status.toString(),
          });
          showSuccess("Status changed successfully");
        } else {
          // Roll number doesn't exist, show warning
          showError("ID does not exist!");
        }
      } catch (error) {
        showError("Failed to change status: $error");
      }

      setState(() {
        lockFaculty = false;
        unlockFaculty = false;
      });
    } else {
      showError("Please fill all fields!");
    }
  }



  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Manage Accounts",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    // color: Colors.black87,
                    color: Colors.white,
                    blurRadius: 10,
                  )
                ],
              ),
              child:  Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Student Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    buildDropdownButtonFormField("Class", ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]),
                    const SizedBox(height: 15,),
                    buildDropdownButtonFormField("Section", ["A","B","C","D","E"]),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: studentRollNoController,
                      decoration: InputDecoration(
                        labelText: 'Roll No',
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        prefixIcon: const Icon(Icons.person),
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
                      padding: const EdgeInsets.only(top: 20,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomizedElevatedButton(text: "Unlock", loading: unlockLoading,onTap: (){
                            setState(() {
                              unlockLoading=true;
                            });
                            changeStatus("unlocked");
                          }),
                          CustomizedElevatedButton(text: "Lock",loading: lockLoading, onTap: (){
                            setState(() {
                              lockLoading=true;
                            });
                            changeStatus("locked");
                          })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomizedElevatedButton(text: "Unlock All",loading: unlockAllStudents,onTap: (){
                            setState(() {
                              unlockAllStudents=true;
                            });
                            final ref=FirebaseDatabase.instance.ref("Manage Accounts");
                            ref.child("Students").set({
                              "status":"unlocked"
                            }).then((value){
                              setState(() {
                                unlockAllStudents=false;
                              });
                            });
                          },),
                          CustomizedElevatedButton(text: "Lock All", loading: lockAllStudents,onTap: (){
                            setState(() {
                              lockAllStudents=true;
                            });
                            final ref=FirebaseDatabase.instance.ref("Manage Accounts");
                            ref.child("Students").set({
                              "status":"locked"
                            }).then((value){
                              setState(() {
                                lockAllStudents=false;
                              });
                            });
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    // color: Colors.black87,
                    color: Colors.white,
                    blurRadius: 10,
                  )
                ],
              ),
              child:  Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Teachers Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: facultyRollNoController,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        prefixIcon: const Icon(Icons.person),
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
                      padding: const EdgeInsets.only(top: 20,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomizedElevatedButton(text: "Unlock", loading: unlockFaculty,onTap: (){
                            setState(() {
                              unlockFaculty=true;
                            });
                            changeStatusTeacher("unlocked");
                          }),
                          CustomizedElevatedButton(text: "Lock", loading: lockFaculty,onTap: (){
                            setState(() {
                              lockFaculty=true;
                            });
                            changeStatusTeacher("locked");
                          })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomizedElevatedButton(text: "Unlock All", loading: unlockAllFaculty,onTap: (){
                            setState(() {
                              unlockAllFaculty=true;
                            });
                            final ref=FirebaseDatabase.instance.ref("Manage Accounts");
                            ref.child("Teachers").set({
                              "status":"unlocked"
                            }).then((value){
                              setState(() {
                                unlockAllFaculty=false;
                              });
                            });
                          }),
                          CustomizedElevatedButton(text: "Lock All", loading: lockAllFaculty,onTap: (){
                            setState(() {
                              lockAllFaculty=true;
                            });
                            final ref=FirebaseDatabase.instance.ref("Manage Accounts");
                            ref.child("Teachers").set({
                              "status":"locked"
                            }).then((value){
                              setState(() {
                                lockAllFaculty=false;
                              });
                            });
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
  Widget buildDropdownButtonFormField(String labelText, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        prefixIcon: const Icon(Icons.person),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: null,
      onChanged: (String? value) {
        setState(() {
          if (labelText == "Class") {
            selectedClass = value;
          } else if (labelText == "Section") {
            selectedSection = value;
          }
        });
      },
    );
  }
}

