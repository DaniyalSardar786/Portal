import 'package:flutter/material.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/admin_announcements.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/add_faculty.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/create_id.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_accounts.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_classes.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_passwords.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/manage_teachers.dart';
import 'Admin_Activities/Results/manage_results.dart';
import 'Admin_Activities/add_student.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Admin Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          SizedBox(width: 2,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 40),
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
                          child: buildSection("images/teacher.png", "Add Teacher")
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
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateIdScreen()));
                            });
                          },
                          child: buildSection("images/face-id.png", "Create Id")
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
                          child: buildSection("images/announcements.png", "Announcements")
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
      drawer:Drawer(
    child: Container(
    color: Colors.blueGrey.shade200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 80,),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddStudentScreen()));
            },
            leading: Image.asset(
              "images/graduated.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Add Student"),
          ),

          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddFacultyScreen()));
            },
            leading: Image.asset(
              "images/teacher.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Add Teacher"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageClassesScreen()));
            },
            leading: Image.asset(
              "images/classroom.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Manage Classes"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageTeachersScreen()));
            },
            leading: Image.asset(
              "images/graduation.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Manage Teachers"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CreateIdScreen()));
            },
            leading: Image.asset(
              "images/face-id.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Create Id"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageAccountsScreen()));
            },
            leading: Image.asset(
              "images/accounts.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Manage Ids"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageResultsScreen()));
            },
            leading: Image.asset(
              "images/exam.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Manage Results"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminAnnouncementScreen()));
            },
            leading: Image.asset(
              "images/announcements.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Announcements"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManagePasswordsScreen()));
            },
            leading: Image.asset(
              "images/password.png",
              width: 30, // Set your desired width
              height: 30, // Set your desired height
            ),
            title: const Text("Manage Passwords"),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);

            },
            leading: (Icon(Icons.logout,size: 30,)),
            title: const Text("Log out"),
          ),
        ],
      ),
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
  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
}


