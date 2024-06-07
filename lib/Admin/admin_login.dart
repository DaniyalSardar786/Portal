import 'package:flutter/material.dart';
import 'package:portal/Admin/Admin_Home/admin_home.dart';
import 'package:portal/Others/elevated_button.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _obscureText = true;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          title: const Text("Admin Login",style: TextStyle(color: Colors.white),),
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
                          decoration: InputDecoration(
                            hintText: "Admin ID",
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                            prefixIcon: const Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:  const BorderSide(color: Colors.green,width: 2)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminHomeScreen()));
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
        // backgroundColor: const Color(0xffcfcdca),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
