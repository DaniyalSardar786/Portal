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
  bool loading = false;
  bool loading2 = false;
  bool loading3 = false;  // For changing faculty password
  bool loading4 = false;

  String? selectedClass;
  String? selectedSection;
  final databaseRef = FirebaseDatabase.instance.ref("Students");

  void changeTeacherPassword() async {
    setState(() {
      loading3 = true;
    });

    if (idController.text.isNotEmpty && newFacultyPasswordController.text.isNotEmpty) {
      final ref = FirebaseDatabase.instance.ref("Teachers").child(idController.text.trim());

      try {
        DataSnapshot? snapshot; // Initialize with null
        await ref.once().then((event) {
          snapshot = event.snapshot;
        });
        if (snapshot != null && snapshot!.value != null) {
          // Roll number exists, proceed to update the password
          await ref.update({
            'password': newFacultyPasswordController.text.trim(),
          });
          showSuccess("Password updated successfully");
        } else {
          // Roll number doesn't exist, show error
          showError("Id does not exist.");
        }
      } catch (error) {
        showError("Failed to update password");
      }
    } else {
      showError("Please fill all fields!");
    }

    setState(() {
      loading3 = false;
    });
  }

  void changeStudentPassword() async {
    setState(() {
      loading = true;
    });

    if (selectedClass != null &&
        selectedSection != null &&
        rollNoController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty) {
      final ref = FirebaseDatabase.instance.ref("Classroom")
          .child(selectedClass!)
          .child(selectedSection!)
          .child(rollNoController.text.trim());

      try {
        DataSnapshot? snapshot; // Initialize with null
        await ref.once().then((event) {
          snapshot = event.snapshot;
        });
        if (snapshot != null && snapshot!.value != null) {
          // Roll number exists, proceed to update the password
          await ref.update({
            'password': newPasswordController.text.trim(),
          });
          showSuccess("Password updated successfully");
        } else {
          // Roll number doesn't exist, show error
          showError("Roll number does not exist.");
        }
      } catch (error) {
        showError("Failed to update password");
      }
    } else {
      showError("Please fill all fields!");
    }

    setState(() {
      loading = false;
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
                    buildDropdownButtonFormField("Class", ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]),
                    const SizedBox(height: 15),
                    buildDropdownButtonFormField("Section", ["A", "B", "C", "D", "E"]),
                    const SizedBox(height: 15),
                    buildTextFields("Roll No", rollNoController),
                    const SizedBox(height: 15),
                    buildTextFields("New Password", newPasswordController),
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
                            onTap: () {
                              if (rollNoController.text.isNotEmpty) {
                                changeStudentPassword();
                              } else {
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
                    buildTextFields("ID", idController),
                    const SizedBox(height: 15),
                    buildTextFields("New Password", newFacultyPasswordController),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomizedElevatedButton(
                            loading: loading4,
                            text: "Default",
                            onTap: () {
                              setState(() {
                                newFacultyPasswordController.text = "welcome123";
                              });
                            },
                          ),
                          CustomizedElevatedButton(
                            loading: loading3,
                            text: "Save",
                            onTap: () {
                              changeTeacherPassword();
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

  Widget buildTextFields(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
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
    );
  }
}
