import 'package:flutter/material.dart';

class AddFacultyScreen extends StatefulWidget {
  const AddFacultyScreen({Key? key}) : super(key: key);

  @override
  State<AddFacultyScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddFacultyScreen> {
  TextEditingController idController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController fatherNameController=TextEditingController();
  TextEditingController dobController=TextEditingController();
  TextEditingController phoneNoController=TextEditingController();
  TextEditingController cnicController=TextEditingController();
  TextEditingController districtController=TextEditingController();
  TextEditingController cityController=TextEditingController();
  TextEditingController domicileController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController studyFieldController=TextEditingController();

  void clearAllControllers() {
    idController.clear();
    passwordController.clear();
    nameController.clear();
    fatherNameController.clear();
    dobController.clear();
    phoneNoController.clear();
    cnicController.clear();
    districtController.clear();
    cityController.clear();
    domicileController.clear();
    addressController.clear();
    studyFieldController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this color to whatever you want
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Add Faculty",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                buildTextField("Faculty ID",idController),
                const SizedBox(height: 15),
                buildTextField("Password",passwordController),
                const SizedBox(height: 10),
                const Text(
                  "Personal Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField("Name",nameController),
                const SizedBox(height: 15),
                buildTextField("Father Name",fatherNameController),
                const SizedBox(height: 15),
                buildTextField("Date of Birth",dobController),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Gender", ["Male", "Female", "Other"]),
                const SizedBox(height: 15),
                buildTextField("Phone No",phoneNoController),
                const SizedBox(height: 15),
                buildTextField("CNIC",cnicController),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Nationality", ["Pakistan", "India", "Afghanistan"]),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Province", ["Punjab", "Sindh", "KPK", "Balochistan"]),
                const SizedBox(height: 15),
                buildTextField("District",districtController),
                const SizedBox(height: 15),
                buildTextField("City",cityController),
                const SizedBox(height: 15),
                buildTextField("Domicile",domicileController),
                const SizedBox(height: 15),
                buildTextField("Address",addressController),
                const SizedBox(height: 10),
                const Text(
                  "Academic Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField("Field of Study",studyFieldController),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Education", ["BS", "MS","PHD"]),
                const SizedBox(height: 15),
                buildDropdownButtonFormField("Teaching Experience", ["Freshie","1 year","2 years","3 years","4 years","5+ years"]),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap:()
                        {
                          setState(() {
                            clearAllControllers();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Add Faculty",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // backgroundColor: const Color(0xffcfcdca),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }

  Widget buildTextField(String labelText,TextEditingController _controller) {
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
      }).toList(), onChanged: (String? value) {  },
    );
  }
}
