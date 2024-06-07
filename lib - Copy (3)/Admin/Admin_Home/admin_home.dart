import 'package:flutter/material.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/admin_announcements.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/Admin_Profile/admin_profile.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/add_faculty.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/create_id.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_accounts.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_classes.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_passwords.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_results.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_teachers.dart';
import 'Admin_Activities/add_student.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("LMS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminProfileScreen()));
                });
              },
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')
                 ),
                 title: Text("Imran Khan",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                 subtitle: Text("See your profile",style: TextStyle(color: Colors.white70)),
              ),
            ),
            const Padding(
               padding: EdgeInsets.only(left: 15,right: 15,bottom: 25),
               child: SizedBox(
                 height: 10,
                  child: Divider(
                  thickness: 2,
                    color: Colors.grey,
                  ),
               ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                      child: InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddStudentScreen()));
                          },
                          child: buildSection("images/graduated.png", "Add Student"))
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddFacultyScreen()));
                          },
                          child: buildSection("images/teacher.png", "Add Faculty")
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageClassesScreen()));
                            });
                          },
                          child: buildSection("images/classroom.png", "Manage Classes")
                      )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageTeachersScreen()));
                            });
                          },
                          child: buildSection("images/graduation.png", "Manage Teachers")
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManagePasswordsScreen()));
                        },
                          child: buildSection("images/password.png", "Manage Passwords")
                      )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageAccountsScreen()));
                            });
                          },
                          child: buildSection("images/accounts.png", "Manage Accounts")
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageResultsScreen()));
                            });
                          },
                          child: buildSection("images/exam.png", "Manage Results")
                      )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminAnnouncementScreen()));
                            });
                          },
                          child: buildSection("images/exam.png", "Announcements")
                      )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateIdScreen()));
                            });
                          },
                          child: buildSection("images/exam.png", "Create Id")
                      )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: buildSection("images/books.png", "Log out")
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
  Widget buildSection(String url,String title) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.white,
                blurRadius: 3
            )
          ]
      ),
      child:  Padding(
        padding: const EdgeInsets.only(left: 10,top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 50,
                child: Image(image:  AssetImage(url),
                  fit: BoxFit.cover,
                  color: Colors.blueGrey.shade700,
                )
            ),
            const SizedBox(height: 5,),
            Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
          ],
        ),
      ),
    );
  }
}
