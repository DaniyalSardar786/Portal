import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class CreateIdScreen extends StatefulWidget {
  const CreateIdScreen({Key? key});

  @override
  State<CreateIdScreen> createState() => _CreateIdScreenState();
}

class _CreateIdScreenState extends State<CreateIdScreen> {
  TextEditingController rollNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController teacherPasswordController = TextEditingController();
  TextEditingController teacherIdController = TextEditingController();
  bool loading = false;
  bool loading2 = false;
  bool loading3=false;
  bool loading4=false;

  String? selectedClass;
  String? selectedSection;

  final databaseRef = FirebaseDatabase.instance.ref("Classroom");
  final ref=FirebaseDatabase.instance.ref("Teachers");

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          "Create Id",
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
                      "Student Id",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    buildDropdownButtonFormField(
                      "Class",
                      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
                          (String? value) {
                        setState(() {
                          selectedClass = value;
                        });
                      },
                      selectedClass,
                    ),
                    const SizedBox(height: 15),
                    buildDropdownButtonFormField(
                      "Section",
                      ["A", "B", "C", "D", "E"],
                          (String? value) {
                        setState(() {
                          selectedSection = value;
                        });
                      },
                      selectedSection,
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
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomizedElevatedButton(
                            text: "Default Password",
                            loading: loading2,
                            onTap: () {
                              setState(() {
                                passwordController.text = "welcome123";
                              });
                            },
                          ),
                          CustomizedElevatedButton(
                            text: "Create Id",
                            loading: loading,
                            onTap: () async {
                              if (rollNoController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty &&
                                  selectedClass != null &&
                                  selectedSection != null) {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  await databaseRef
                                      .child(selectedClass.toString()).child(selectedSection.toString()).child(rollNoController.text.toString()).set({
                                    "class": selectedClass,
                                    "section": selectedSection,
                                    "roll_no": rollNoController.text,
                                    "password": passwordController.text.toString(),
                                    "status": "unlocked"
                                  });
                                  snackBar("Student id created");
                                } catch (error) {
                                  print("Error: $error");
                                  snackBar("Error creating student id");
                                } finally {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              } else {
                                snackBar("Please fill in all fields");
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
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
                      "Teacher Id",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: teacherIdController,
                      decoration: InputDecoration(
                        labelText: 'Teacher Id',
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
                      controller: teacherPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomizedElevatedButton(
                            text: "Default Password",
                            loading: loading4,
                            onTap: () {
                              setState(() {
                                teacherPasswordController.text = "welcome123";
                              });
                            },
                          ),
                          CustomizedElevatedButton(
                            text: "Create Id",
                            loading: loading3,
                            onTap: () async {
                              if (teacherIdController.text.isNotEmpty &&
                                  teacherPasswordController.text.isNotEmpty)
                              {
                                setState(() {
                                  loading3 = true;
                                });
                                try {
                                  await ref
                                      .child(teacherIdController.text).set({
                                    "id":teacherIdController.text,
                                    "password": teacherPasswordController.text,
                                    "status": "unlocked"
                                  });
                                  snackBar("Teacher id created");
                                } catch (error) {
                                  snackBar("Error creating Teacher id");
                                } finally {
                                  setState(() {
                                    loading3 = false;
                                  });
                                }
                              } else {
                                snackBar("Please fill in all fields");
                              }
                            },
                          )
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

  Widget buildDropdownButtonFormField(
      String labelText,
      List<String> items,
      ValueChanged<String?> onChanged,
      String? currentValue,
      ) {
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
      value: currentValue,
      onChanged: onChanged,
    );
  }

}

