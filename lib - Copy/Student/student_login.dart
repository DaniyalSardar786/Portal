import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';
import 'package:portal/Student/Student_Home/student_home.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  bool _obscureText = true;
  TextEditingController rollNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref("Students");
  bool loading=false;

  void login() async {
    setState(() {
      loading=true;
    });
    String rollNo = rollNoController.text;
    String password = passwordController.text;

    if (rollNo.isEmpty || password.isEmpty) {
      showError("Please fill all fields");
      setState(() {
        loading=false;
      });
      return;
    }

    try {
      // Fetch the data for the given roll number
      DatabaseEvent event = await databaseRef.child(rollNo).once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          String storedPassword = data['password'];

          if (storedPassword == password) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StudentHomeScreen(roll_no: rollNoController.text.toString(),password: passwordController.text.toString(),)),
            );
          } else {
            showError("Invalid roll number or password");
          }
        } else {
          showError("Data format error");
        }
      } else {
        showError("Invalid roll number or password");
      }
      setState(() {
        loading=false;
      });
    } catch (e) {
      showError("An error occurred: $e");
      setState(() {
        loading=false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Student Login",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 140),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage("https://images.pexels.com/photos/2835170/pexels-photo-2835170.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextFormField(
                        controller: rollNoController,
                        decoration: InputDecoration(
                          hintText: "Roll No",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          prefixIcon: const Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "Password",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          prefixIcon: const Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomizedElevatedButton(text: "Login", onTap: login,loading: loading,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
