import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class AddFacultyScreen extends StatefulWidget {
  const AddFacultyScreen({Key? key}) : super(key: key);

  @override
  State<AddFacultyScreen> createState() => _AddFacultyScreenState();
}

class _AddFacultyScreenState extends State<AddFacultyScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController domicileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  String? selectedGender;
  String? selectedProvince;
  String? selectedEducation;
  String? selectedTeachingExperience;

  bool loading = false;

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void clearAllControllers() {
    idController.clear();
    nameController.clear();
    fatherNameController.clear();
    dobController.clear();
    phoneNoController.clear();
    cnicController.clear();
    domicileController.clear();
    addressController.clear();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Add Faculty",
          style: TextStyle(color: Colors.white),
        ),
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
                const Text(
                  "Enter Faculty Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField("Faculty ID", idController),
                const SizedBox(height: 10),
                const Text(
                  "Personal Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField("Name", nameController),
                const SizedBox(height: 15),
                buildTextField("Father Name", fatherNameController),
                const SizedBox(height: 15),
                buildTextField("Date of Birth(DD-MM-YY)", dobController),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Gender", ["Male", "Female", "Other"], (value) {
                  selectedGender = value;
                }),
                const SizedBox(height: 15),
                buildTextField("Phone No", phoneNoController),
                const SizedBox(height: 15),
                buildTextField("CNIC", cnicController),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Province", ["Punjab", "Sindh", "KPK", "Balochistan"], (value) {
                  selectedProvince = value;
                }),
                const SizedBox(height: 15),
                buildTextField("Domicile", domicileController),
                const SizedBox(height: 15),
                buildTextField("Email", emailController),
                const SizedBox(height: 15,),
                buildTextField("Address", addressController),
                const SizedBox(height: 10),
                const Text(
                  "Academic Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                buildDropdownButtonFormField("Education", ["FSc", "BS", "MS", "PHD"], (value) {
                  selectedEducation = value;
                }),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Teaching Experience", ["Freshie", "1 year", "2 years", "3 years", "4 years", "5+ years"], (value) {
                  selectedTeachingExperience = value;
                }),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomizedElevatedButton(
                          text: "Add Teacher",
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
                              await ref.child(idController.text).set({
                                "id": idController.text.toString(),
                                "password": "welcome123",
                                "status": "unlocked",
                                "name": nameController.text,
                                "father_name": fatherNameController.text,
                                "dob": dobController.text,
                                "gender": selectedGender,
                                "phone_no": phoneNoController.text,
                                "cnic": cnicController.text,
                                "province": selectedProvince,
                                "domicile": domicileController.text,
                                "email":emailController.text,
                                "address": addressController.text,
                                "education": selectedEducation,
                                "teaching_exp": selectedTeachingExperience,
                              });
                              snackBar("Teacher added successfully!");
                            }
                            else {
                              snackBar("Please enter ID!");
                            }
                            setState(() {
                              loading = false;
                            });
                          }),
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

  Widget buildTextField(String labelText, TextEditingController _controller) {
    return TextFormField(
      controller: _controller,
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

  Widget buildDropdownButtonFormField(String labelText, List<String> items, ValueChanged<String?> onChanged) {
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
      onChanged: onChanged,
    );
  }
}
