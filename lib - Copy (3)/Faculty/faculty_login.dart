import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Faculty/Faculty_Home/faculty_home.dart';
import 'package:portal/Others/elevated_button.dart';

class FacultyLoginScreen extends StatefulWidget {
  const FacultyLoginScreen({super.key});

  @override
  State<FacultyLoginScreen> createState() => _FacultyLoginScreenState();
}

class _FacultyLoginScreenState extends State<FacultyLoginScreen> {
  bool _obscureText = true;
  bool loading=false;
  TextEditingController idController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final databaseRef=FirebaseDatabase.instance.ref("Teachers");

  void login() async {
    setState(() {
      loading = true;
    });
    String id = idController.text;
    String password = passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      showError("Please fill all fields");
      setState(() {
        loading = false;
      });
      return;
    }

    try {
      // Fetch the data for the given class, section, and roll number
      DatabaseEvent event = await databaseRef.child(id).once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          String storedPassword = data['password'];

          if (storedPassword == password) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FacultyHomeScreen(id: id,password: password),
              ));
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
        loading = false;
      });
    } catch (e) {
      showError("An error occurred: $e");
      setState(() {
        loading = false;
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
        title: const Text("Faculty Login",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
      ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 400,
              margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 140),
              decoration:  BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 10
                    )
                  ]
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
                          backgroundImage: AssetImage("images/logo.png")
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextFormField(
                          controller: idController,
                          decoration: InputDecoration(
                            hintText: "Teacher ID",
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                            prefixIcon: const Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.green,width: 2),
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
                              borderSide: const BorderSide(color: Colors.green,width: 2),
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
                          CustomizedElevatedButton(text: "Login",loading: loading, onTap: (){
                            setState(() {
                              login();
                            });
                          })
                        ],
                      ),
                    )
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
