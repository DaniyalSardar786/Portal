import 'package:flutter/material.dart';

import '../Admin/admin_login.dart';
import '../Faculty/faculty_login.dart';
import '../Student/student_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Management System",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 180),
                height: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 10
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage("https://images.pexels.com/photos/207692/pexels-photo-207692.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const StudentLoginScreen()));
                            },
                            child: Container(
                              width: 80,
                              height: 90,
                              decoration:  BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blueGrey.shade600,
                                        blurRadius: 5
                                    )
                                  ]
                              ),
                              child: const Column(
                                children: [
                                  SizedBox(height: 5,),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage('https://images.pexels.com/photos/7944061/pexels-photo-7944061.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                  ),
                                  Text("Student")
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const FacultyLoginScreen()));
                            },
                            child: Container(
                              width: 80,
                              height: 90,
                              decoration:  BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blueGrey.shade600,
                                        blurRadius: 10
                                    )
                                  ]
                              ),
                              child: const Column(
                                children: [
                                  SizedBox(height: 5,),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage('https://images.pexels.com/photos/5212317/pexels-photo-5212317.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                  ),
                                  Text("Faculty")
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminLoginScreen()));
                            },
                            child: Container(
                              width: 80,
                              height: 90,
                              decoration:  BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blueGrey.shade600,
                                        blurRadius: 10
                                    )
                                  ]
                              ),
                              child:  Column(
                                children: [
                                  const SizedBox(height: 5,),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey.withOpacity(.2),
                                    child: const Icon(Icons.person,size: 55,),
                                  ),
                                  const Text("Admin")
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
        // backgroundColor: const Color(0xffcfcdca),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}
