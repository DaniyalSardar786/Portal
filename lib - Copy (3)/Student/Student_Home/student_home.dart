import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal/Others/elevated_button.dart';
import 'package:portal/Others/snackbar.dart';
import 'package:portal/Student/Student_Home/Student_Activities/Announcements/announcements_screen.dart';
import 'package:portal/Student/Student_Home/Student_Activities/chat_bot.dart';
import 'package:portal/Student/Student_Home/Student_Activities/student_grades.dart';
import 'Student_Activities/change_password.dart';
import 'Student_Activities/student_attendance.dart';

class StudentHomeScreen extends StatefulWidget {
  final String roll_no;
  final String password;
  final String classs;
  final String section;
  const StudentHomeScreen(
      {Key? key,
      required this.roll_no,
      required this.password,
      required this.classs,
      required this.section})
      : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref("Classroom");
  Map<String, dynamic>? studentData;
  Map<String, dynamic>? statusInfo;
  TextEditingController rollNoController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController sectionController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController domicileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
    fetchStatus();
    Status();
  }

  bool Status() {
    if (studentData?["status"] == "locked" ||
        statusInfo?["status"] == "locked") {
      return true;
    } else {
      return false;
    }
  }

  void fetchStudentData() async {
    final snapshot = await ref
        .child(widget.classs) // Class
        .child(widget.section) // Section
        .child(widget.roll_no) // Roll number
        .get();

    if (snapshot.exists) {
      setState(() {
        studentData = Map<String, dynamic>.from(snapshot.value as Map);
        // Populate the controllers with the fetched data
        rollNoController.text = widget.roll_no;
        classController.text = widget.classs;
        sectionController.text = widget.section;

        // Populate other controllers with student info
        nameController.text = studentData?['name'] ?? '';
        fatherNameController.text = studentData?['father_name'] ?? '';
        cnicController.text = studentData?['cnic'] ?? '';
        domicileController.text = studentData?['domicile'] ?? '';
        genderController.text = studentData?["gender"] ?? '';
        dobController.text = studentData?['dob'] ?? '';
        addressController.text = studentData?['address'] ?? '';
        emailController.text = studentData?['email'] ?? '';
        phoneNoController.text = studentData?['phone_no'] ?? '';
      });
    } else {
      setState(() {
        studentData = null;
        clearAllControllers();
      });
      print('No data available.');
    }
  }

  void fetchStatus() async {
    final infoRef = FirebaseDatabase.instance.ref("Manage Accounts");
    final snapshot = await infoRef.child("Students").get();

    if (snapshot.exists) {
      setState(() {
        statusInfo = Map<String, dynamic>.from(snapshot.value as Map);
      });
    } else {}
  }

  void clearAllControllers() {
    rollNoController.clear();
    nameController.clear();
    fatherNameController.clear();
    dobController.clear();
    genderController.clear();
    phoneNoController.clear();
    cnicController.clear();
    domicileController.clear();
    addressController.clear();
    emailController.clear();
  }

  File? _image; // Variable to store the picked image
  final picker = ImagePicker();

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to upload image to Firebase Storage and add student data to Realtime Database
  Future<void> _uploadAndAddStudent() async {
    setState(() {
      uploadLoading=true;
    });
    if (_image == null) {
      print("No image selected");
      return;
    }

    String rollNo = widget.roll_no;

    if (rollNo.isEmpty) {
      print("Roll number is empty");
      return;
    }

    String fileName = rollNo + ".jpg"; // Define file name for the image
    Reference storageRef =
        FirebaseStorage.instance.ref().child('images/${widget.classs}/${widget.section}/$fileName');
    UploadTask uploadTask = storageRef.putFile(_image!);

    // Wait for the image to upload and get download URL
    String imageUrl = await (await uploadTask).ref.getDownloadURL();

    final databaseRef = FirebaseDatabase.instance.ref("Classroom");
    // Save student data and image URL to Realtime Database
    databaseRef
        .child(widget.classs)
        .child(widget.section)
        .child(rollNo)
        .update({
      "image_url": imageUrl, // Store image URL in database
    }).then((_) {
      setState(() {
        Utils().toastMessage("Image Uploaded");
        uploadLoading=false;
      });
      print("Student added");
    }).catchError((error) {
      setState(() {
        Utils().toastMessage("Try again");
        uploadLoading=false;
      });
      print("Failed to add student: $error");
    });
    setState(() {
      uploadLoading=false;
    });
  }

  bool uploadLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Student Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const MockBot()));
              },
              icon: const Icon(Icons.search)),
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(studentData?['image_url'] ??
                        'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  ),
                  title: Text(
                    nameController.text.isNotEmpty
                        ? nameController.text
                        : "Your Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  subtitle: Text("Student AUST",
                      style: TextStyle(color: Colors.blueGrey.shade500)),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildTextFieldsLock("Roll No", rollNoController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFieldsLock("Class", classController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFieldsLock("Section", sectionController),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Personal Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildTextFields("Name", nameController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Father Name", fatherNameController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("CNIC / B-Form", cnicController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Gender", genderController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Domicile District", domicileController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Date of Birth (DD/MM/YY)", dobController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Phone", phoneNoController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Email", emailController),
                const SizedBox(
                  height: 20,
                ),
                buildTextFields("Address", addressController),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
                      child: Text("Pick Image"),
                    ),
                    SizedBox(height: 30),
                    // Add button
                    CustomizedElevatedButton(text: "Upload Image", onTap: (){
                      _uploadAndAddStudent();
                    }, loading: uploadLoading)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomizedElevatedButton(
                          text: "Save Info",
                          loading: loading,
                          onTap: () {
                            final ref =
                                FirebaseDatabase.instance.ref("Classroom");

                            setState(() {
                              loading = true;
                            });
                            ref
                                .child(widget.classs)
                                .child(widget.section)
                                .child(widget.roll_no)
                                .update({
                              "password": widget.password.toString(),
                              "roll_no": widget.roll_no,
                              "class": widget.classs,
                              "section": widget.section,
                              "name": nameController.text.toString(),
                              "father_name":
                                  fatherNameController.text.toString(),
                              "gender": genderController.text.toString(),
                              "cnic": cnicController.text.toString(),
                              "domicile": domicileController.text.toString(),
                              "dob": dobController.text.toString(),
                              "address": addressController.text.toString(),
                              "phone_no": phoneNoController.text.toString(),
                              "email": emailController.text.toString(),
                              "status": "unlocked"
                            }).then((value) {
                              setState(() {
                                loading = false;
                              });
                            }).onError((error, stackTrace) {
                              setState(() {
                                print("Error");
                                loading = false;
                              });
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
      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey.shade200,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade700,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 12,
                    )
                  ],
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(studentData?['image_url'] ??
                      'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                ),
                accountName: Text(studentData?['name'] ?? ''),
                accountEmail: Text(widget.roll_no),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentHomeScreen(
                                roll_no: widget.roll_no,
                                password: widget.password,
                                section: widget.section,
                                classs: widget.classs,
                              )));
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MockBot()));
                },
                leading: const Icon(Icons.search),
                title: const Text("Ask AI"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentAttendanceScreen(
                            roll_no: widget.roll_no,
                            class_name: widget.classs,
                            section: widget.section,
                          )));
                },
                leading: const Icon(Icons.co_present_outlined),
                title: const Text("Attendance"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentGradesScreen(classs: widget.classs,section: widget.section,roll_no:widget.roll_no)));
                },
                leading: const Icon(Icons.feed),
                title: const Text("Grades"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnnouncementsScreen(
                            class_name: widget.classs,
                            class_section: widget.section,
                          )));
                },
                leading: Icon(Icons.pin_end_rounded),
                title: Text("Announcements"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(
                                studentDataFromHome: studentData,
                                classs: widget.classs,
                                section: widget.section,
                              )));
                },
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }

  Widget buildTextFields(String labelText, TextEditingController controller) {
    return TextFormField(
      readOnly: Status(),
      // enabled: Status(),
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

  Widget buildTextFieldsLock(
      String labelText, TextEditingController controller) {
    return TextFormField(
      readOnly: true,
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

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
}
