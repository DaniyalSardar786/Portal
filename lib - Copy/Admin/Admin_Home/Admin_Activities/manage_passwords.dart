import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class ManagePasswordsScreen extends StatefulWidget {
  const ManagePasswordsScreen({super.key});

  @override
  State<ManagePasswordsScreen> createState() => _ManagePasswordsScreenState();
}

class _ManagePasswordsScreenState extends State<ManagePasswordsScreen> {
  TextEditingController rollNoController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController newFacultyPasswordController = TextEditingController();
  bool loading=false;
  bool loading2=false;

  final databaseRef = FirebaseDatabase.instance.ref("Students");

  void changeStudentPassword() async {
    setState(() {
      loading=true;
    });
    DatabaseEvent event = await databaseRef.child(rollNoController.text.trim()).once();

    if (event.snapshot.exists) {
      await databaseRef.child(rollNoController.text.trim()).update({
        'password': newPasswordController.text.trim(),
      });
      showSuccess("Password updated successfully");
    } else {
      showError("Invalid roll number");
    }
    setState(() {
      loading=false;
    });
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
        title: const Text(
          "Manage Passwords",
          style: TextStyle(color: Colors.white),
        ),
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
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change Student Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: rollNoController,
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
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
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
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomizedElevatedButton(
                            loading: loading2,
                            text: "Default",
                            onTap: () {
                              setState(() {

                                newPasswordController.text = "welcome123";
                              });
                            },
                          ),
                          CustomizedElevatedButton(
                            loading: loading,
                            text: "Save",
                            onTap: (){
                              if(rollNoController.text.isNotEmpty){

                                changeStudentPassword();
                              }else{
                                showError("Enter Roll No!!");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change Faculty Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: idController,
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
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: newFacultyPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
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
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomizedElevatedButton(
                            loading: loading,
                            text: "Default",
                            onTap: () {
                              setState(() {
                                newFacultyPasswordController.text = "welcome123";
                              });
                            },
                          ),
                          CustomizedElevatedButton(loading: loading,
                            text: "Save",
                            onTap: () {
                              // Implement changeFacultyPassword similar to changeStudentPassword
                            },
                          ),
                        ],
                      ),
                    ),
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
}
