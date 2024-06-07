import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Others/elevated_button.dart';
import '../../../Others/snackbar.dart';

class FacultyProfileScreen extends StatefulWidget {
  final String id;
  final String password;
  const FacultyProfileScreen({Key? key, required this.id, required this.password}) : super(key: key);

  @override
  State<FacultyProfileScreen> createState() => _FacultyProfileScreenState();
}

class _FacultyProfileScreenState extends State<FacultyProfileScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController domicileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController teachingExpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
  }

  void clearAllControllers() {
    idController.clear();
    nameController.clear();
    fatherNameController.clear();
    dobController.clear();
    genderController.clear();
    phoneNoController.clear();
    cnicController.clear();
    provinceController.clear();
    domicileController.clear();
    emailController.clear();
    addressController.clear();
    educationController.clear();
    teachingExpController.clear();
  }

  bool Status() {
    if (teacherData?["status"] == "locked") {
      return true;
    } else {
      return false;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref("Teachers");
  Map<String, dynamic>? teacherData;

  void fetchTeacherData() async {
    final snapshot = await ref.child(widget.id).get();

    if (snapshot.exists) {
      setState(() {
        teacherData = Map<String, dynamic>.from(snapshot.value as Map);
        // Populate the controllers with the fetched data
        idController.text = widget.id;
        nameController.text = teacherData?['name'] ?? '';
        fatherNameController.text = teacherData?['father_name'] ?? '';
        dobController.text = teacherData?['dob'] ?? '';
        genderController.text = teacherData?["gender"] ?? '';
        phoneNoController.text = teacherData?['phone_no'] ?? '';
        cnicController.text = teacherData?['cnic'] ?? '';
        provinceController.text = teacherData?["province"] ?? '';
        domicileController.text = teacherData?['domicile'] ?? '';
        addressController.text = teacherData?['address'] ?? '';
        emailController.text = teacherData?['email'] ?? '';
        educationController.text = teacherData?['education'] ?? '';
        teachingExpController.text = teacherData?['teaching_exp'] ?? '';
      });
    } else {
      setState(() {
        teacherData = null;
        clearAllControllers();
      });
      print('No data available.');
    }
  }

  bool loading = false;

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool uploadLoading=false;
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

    String id = widget.id;


    String fileName = id + ".jpg"; // Define file name for the image
    Reference storageRef =
    FirebaseStorage.instance.ref().child('Teachers images/${widget.id}/$fileName');
    UploadTask uploadTask = storageRef.putFile(_image!);

    // Wait for the image to upload and get download URL
    String imageUrl = await (await uploadTask).ref.getDownloadURL();

    final databaseRef = FirebaseDatabase.instance.ref("Teachers");
    // Save student data and image URL to Realtime Database
    databaseRef
        .child(id)
        .update({
      "image_url": imageUrl, // Store image URL in database
    }).then((_) {
      setState(() {
        Utils().toastMessage("Image Uploaded");
        uploadLoading=false;
      });
      print("Teacher added");
    }).catchError((error) {
      setState(() {
        Utils().toastMessage("Try again");
        uploadLoading=false;
      });
      print("Failed to add Teacher: $error");
    });
    setState(() {
      uploadLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Faculty Profile", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                ListTile(
                  leading: CircleAvatar(
                backgroundImage: NetworkImage(teacherData?['image_url'] ?? 'https://images.pexels.com/photos/6326377/pexels-photo-6326377.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
            ),
                  title: Text(
                      teacherData?['name'] ?? 'Teacher Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
                  ),
                  subtitle:
                  Text("Teacher AUST", style: TextStyle(color: Colors.blueGrey.shade500)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: "ID",
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
                buildTextField("Name", nameController),
                const SizedBox(height: 15),
                buildTextField("Father Name", fatherNameController),
                const SizedBox(height: 15),
                buildTextField("Date of Birth", dobController),
                const SizedBox(height: 15),
                buildTextField("Gender", genderController),
                const SizedBox(height: 15),
                buildTextField("Phone No", phoneNoController),
                const SizedBox(height: 15),
                buildTextField("CNIC", cnicController),
                const SizedBox(height: 15),
                buildTextField("Province", provinceController),
                const SizedBox(height: 15),
                buildTextField("Domicile", domicileController),
                const SizedBox(height: 15),
                buildTextField("Email", emailController),
                const SizedBox(height: 15),
                buildTextField("Address", addressController),
                const SizedBox(height: 15),
                buildTextField("Education", educationController),
                const SizedBox(height: 15),
                buildTextField("Teaching Experience", teachingExpController),
                SizedBox(height: 15,),
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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomizedElevatedButton(
                        text: "Save Info",
                        loading: loading,
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          final ref = FirebaseDatabase.instance.ref("Teachers");

                          if (idController.text.isNotEmpty) {
                            // Check if the ID already exists
                            final snapshot = await ref.child(idController.text).once();
                            // ID does not exist, add the teacher
                            await ref.child(idController.text).update({
                              "id": idController.text.toString(),
                              "password": widget.password.toString(),
                              "status": "unlocked",
                              "name": nameController.text,
                              "father_name": fatherNameController.text,
                              "dob": dobController.text,
                              "gender": genderController.text,
                              "phone_no": phoneNoController.text,
                              "cnic": cnicController.text,
                              "province": provinceController.text,
                              "domicile": domicileController.text,
                              "email": emailController.text,
                              "address": addressController.text,
                              "education": educationController.text,
                              "teaching_exp": teachingExpController.text,
                            });
                            snackBar("Info Saved!!");
                          } else {
                            snackBar("Please enter ID!");
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      readOnly: Status(),
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
