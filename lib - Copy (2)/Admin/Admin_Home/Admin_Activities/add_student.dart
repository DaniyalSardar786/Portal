import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  bool loading = false;
  String? selectedClass;
  String? selectedSection;
  TextEditingController roll_no_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController father_name_controller = TextEditingController();
  TextEditingController cnic_controller = TextEditingController();
  TextEditingController district_controller = TextEditingController();
  TextEditingController dob_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController phone_no_controller = TextEditingController();

  void showCustomSnackBar(String message, {Color? backgroundColor}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor ?? Colors.green.shade700,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void clearAllControllers() {
    roll_no_controller.clear();
    name_controller.clear();
    father_name_controller.clear();
    cnic_controller.clear();
    district_controller.clear();
    dob_controller.clear();
    email_controller.clear();
    address_controller.clear();
    phone_no_controller.clear();
  }

  Future<void> addStudent() async {
    setState(() {
      loading = true;
    });

    if (roll_no_controller.text.isNotEmpty && selectedClass!.isNotEmpty && selectedSection!.isNotEmpty) {
      final ref = FirebaseDatabase.instance.ref("Classroom");
      try {
        await ref
            .child(selectedClass.toString()) // Class
            .child(selectedSection.toString()) // Section
            .child(roll_no_controller.text.toString()) // Roll number
            .set({
          "password": "welcome123",
          "roll_no": roll_no_controller.text.toString(),
          "name": name_controller.text.toString(),
          "father_name": father_name_controller.text.toString(),
          "cnic": cnic_controller.text.toString(),
          "domicile": district_controller.text.toString(),
          "dob": dob_controller.text.toString(),
          "address": address_controller.text.toString(),
          "phone_no": phone_no_controller.text.toString(),
          "email": email_controller.text.toString(),
          "status": "unlocked"
        });
        showCustomSnackBar("Student Added Successfully!", backgroundColor: Colors.green.shade700);
        clearAllControllers();
      } catch (error) {
        showCustomSnackBar("Failed to add student!", backgroundColor: Colors.red.shade700);
      }
    } else {
      showCustomSnackBar("Roll No is required!", backgroundColor: Colors.red.shade700);
    }

    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Add Student", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 40),
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
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter Student Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                buildTextFields("Roll No", roll_no_controller),
                const SizedBox(height: 20),
                buildDropdownButtonFormField("Class", ["1","2","3","4","5","6","7","8","9","10","11","12"]),
                const SizedBox(height: 20),
                buildDropdownButtonFormField("Section", ["A", "B", "C", "D", "E"]),
                const SizedBox(height: 20),

                buildTextFields("Name", name_controller),
                const SizedBox(height: 20),
                buildTextFields("Father Name", father_name_controller),
                const SizedBox(height: 20),
                buildTextFields("CNIC / B-Form", cnic_controller),
                const SizedBox(height: 20),
                buildDropdownButtonFormField("Gender", ["Male","Female"]),
                const SizedBox(height: 20),
                buildTextFields("Domicile District", district_controller),
                const SizedBox(height: 20),
                buildTextFields("Date of Birth (DD/MM/YY)", dob_controller),
                const SizedBox(height: 20),
                buildTextFields("Phone", phone_no_controller),
                const SizedBox(height: 20),
                buildTextFields("Email", email_controller),
                const SizedBox(height: 20),
                buildTextFields("Address", address_controller),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomizedElevatedButton(
                        text: "Add Student",
                        loading: loading,
                        onTap: addStudent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }

  Widget buildDropdownButtonFormField(String labelText, List<String> items) {
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
      value: null,
      onChanged: (String? value) {
        setState(() {
          if (labelText == "Class") {
            selectedClass = value;
          } else if (labelText == "Section") {
            selectedSection = value;
          }
        });
      },
    );
  }

  Widget buildTextFields(String labelText, TextEditingController controller) {
    return TextFormField(
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
