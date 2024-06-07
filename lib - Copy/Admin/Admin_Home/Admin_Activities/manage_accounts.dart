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
    DatabaseEvent event = await databaseRef.child(studentRollNoController.text.trim()).once();

    if (event.snapshot.exists) {
      await databaseRef.child(studentRollNoController.text.trim()).update({
        'status': status.toString(),
      });
      showSuccess(status.toString());
    } else {
      showError("Invalid roll number");
    }
    setState(() {
      unlockLoading=false;
      lockLoading=false;
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
                          CustomizedElevatedButton(text: "Unlock All",loading: unlockAllStudents,onTap: (){},),
                          CustomizedElevatedButton(text: "Lock All", loading: lockAllStudents,onTap: (){})
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
                      "Faculty Account",
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
                          CustomizedElevatedButton(text: "Unlock", loading: unlockFaculty,onTap: (){}),
                          CustomizedElevatedButton(text: "Lock", loading: lockFaculty,onTap: (){})
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomizedElevatedButton(text: "Unlock All", loading: unlockAllFaculty,onTap: (){}),
                          CustomizedElevatedButton(text: "Lock All", loading: lockAllFaculty,onTap: (){})
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

}

