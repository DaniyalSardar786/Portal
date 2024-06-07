import 'package:flutter/material.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController domicileController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLocked = false;

  void clearAllControllers() {
    idController.clear();
    nameController.clear();
    fatherNameController.clear();
    dobController.clear();
    phoneNoController.clear();
    cnicController.clear();
    districtController.clear();
    cityController.clear();
    domicileController.clear();
    addressController.clear();
  }

  void lockTextFields() {
    setState(() {
      isLocked = true;
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
        title: const Text(
          "Admin Profile",
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
                 ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  ),
                  title: Text(
                    "Imran Khan",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
                  ),
                  subtitle:
                  Text("Coordinator AUST", style: TextStyle(color: Colors.blueGrey.shade500)),
                ),
                const SizedBox(height: 15,),
                buildTextFields("ID", idController),
                const SizedBox(height: 15,),
                buildTextFields("Name", nameController),
                const SizedBox(height: 15,),
                buildTextFields("Father Name", fatherNameController),
                const SizedBox(height: 15,),
                buildTextFields("Date of Birth", dobController),
                const SizedBox(height: 15,),
                buildTextFields("Gender", genderController),
                const SizedBox(height: 15,),
                buildTextFields("Phone No", phoneNoController),
                const SizedBox(height: 15,),
                buildTextFields("CNIC", cnicController),
                const SizedBox(height: 15,),
                buildTextFields("District", districtController),
                const SizedBox(height: 15,),
                buildTextFields("City", cityController),
                const SizedBox(height: 15,),
                buildTextFields("Domicile", domicileController),
                const SizedBox(height: 15,),
                buildTextFields("Address", addressController),

                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            // lockTextFields();
                            if(isLocked){
                              setState(() {
                                isLocked=false;
                              });
                            }
                            else{
                              setState(() {
                                isLocked=true;
                              });
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  Center(
                            child: Text(
                              isLocked ?"Edit Info":"Save Info" ,
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
      backgroundColor: Colors.blueGrey.shade700,
    );
  }

  Widget buildTextFields(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: isLocked, // Set readOnly based on isLocked flag
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
