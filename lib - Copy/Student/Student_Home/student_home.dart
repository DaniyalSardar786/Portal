import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';
import 'package:portal/Student/Student_Home/Student_Activities/attendance.dart';
import 'package:portal/Student/Student_Home/Student_Activities/student_grades.dart';
import 'Student_Activities/change_password.dart';

class StudentHomeScreen extends StatefulWidget {
  final String roll_no;
  final String password;
  const StudentHomeScreen({Key? key, required this.roll_no,required this.password}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref("Students");
  Map<String, dynamic>? studentData;

  TextEditingController rollNoController = TextEditingController();
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
  TextEditingController emailController = TextEditingController();

  bool loading=false;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  bool Status(){
    if(studentData?["status"]=="locked"){
      return true;
    }else{
      return false;
    }
  }

  void fetchStudentData() async {
    final snapshot = await ref.child(widget.roll_no).get(); // Use the roll number from the constructor
    if (snapshot.exists) {
      setState(() {
        studentData = Map<String, dynamic>.from(snapshot.value as Map);
        // Populate the controllers with the fetched data
        rollNoController.text = widget.roll_no;
        nameController.text = studentData?['name'] ?? '';
        fatherNameController.text = studentData?['father_name'] ?? '';
        cnicController.text = studentData?['cnic'] ?? '';
        districtController.text = studentData?['domicile'] ?? '';
        dobController.text = studentData?['dob'] ?? '';
        addressController.text = studentData?['address'] ?? '';
        emailController.text=studentData?['email'] ?? '';
        phoneNoController.text = studentData?['phone_no'] ?? '';

        cityController.text = studentData?['city'] ?? '';


      });
    } else {
      setState(() {
        studentData = null;
        clearAllControllers();
      });
      print('No data available.');
    }
  }

  void clearAllControllers() {
    rollNoController.clear();
    nameController.clear();
    fatherNameController.clear();
    dobController.clear();
    genderController.clear();
    phoneNoController.clear();
    cnicController.clear();
    districtController.clear();
    cityController.clear();
    domicileController.clear();
    addressController.clear();
    emailController.clear();
  }

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
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  ),
                  title:Text(
                    nameController.text.isNotEmpty ? nameController.text : "Your Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  subtitle: Text("Student AUST", style: TextStyle(color: Colors.blueGrey.shade500)),
                ),
                const SizedBox(height: 20,),
                buildTextFields("Roll No", rollNoController),
                const SizedBox(height: 20,),
                buildTextFields("Name", nameController),
                const SizedBox(height: 20,),
                buildTextFields("Father Name", fatherNameController),
                const SizedBox(height: 20,),
                buildDropdownButtonFormField("Batch", ['F22', 'S23', 'F23', 'S24', 'F24']),
                const SizedBox(height: 20,),
                buildDropdownButtonFormField("Department", ["CS", "SE"]),
                const SizedBox(height: 20,),
                buildDropdownButtonFormField("Semester", ["1", "2", "3", "4", "5", "6", "7", "8"]),
                const SizedBox(height: 20,),
                buildDropdownButtonFormField("Section", ["A", "B", "C", "D", "E"]),
                const SizedBox(height: 20,),
                buildTextFields("CNIC / B-Form", cnicController),
                const SizedBox(height: 20,),
                buildDropdownButtonFormField("Province", ["Balochistan", "KPK", "Sindh", "Punjab"]),
                const SizedBox(height: 20,),
                buildTextFields("Domicile District", districtController),
                const SizedBox(height: 20,),
                buildTextFields("Date of Birth (DD/MM/YY)", dobController),
                const SizedBox(height: 20,),
                buildDropdownButtonFormField("Gender", ["Male", "Female"]),
                const SizedBox(height: 20,),
                buildTextFields("Email", emailController),
                const SizedBox(height: 20,),
                buildTextFields("Address", addressController),
                const SizedBox(height: 20,),
                buildTextFields("Phone", phoneNoController),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomizedElevatedButton(text: "Save Info", loading: loading,onTap: (){
                        final ref = FirebaseDatabase.instance.ref("Students");
                        if(studentData?['status']=="unlocked"){
                          setState(() {
                            loading=true;
                            ref.child(rollNoController.text.toString()).set({
                              "password": widget.password.toString(),
                              "roll_no":rollNoController.text.toString(),
                              "name":nameController.text.toString(),
                              "father_name":fatherNameController.text.toString(),
                              "cnic":cnicController.text.toString(),
                              "domicile":districtController.text.toString(),
                              "dob":dobController.text.toString(),
                              "address":addressController.text.toString(),
                              "phone_no":phoneNoController.text.toString(),
                              "email":emailController.text.toString(),
                              "status":"unlocked"
                            }).then((value){
                              setState(() {
                                loading=false;
                              });
                            }).onError((error, stackTrace){
                              setState(() {
                                loading=false;
                              });
                            });
                          });
                        }else{
                          print("kdr bahi??? set o hai na??");
                        }
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
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=600'),
                ),
                accountName:  Text(studentData?['name'] ?? ''),
                accountEmail:  Text(widget.roll_no),
              ),
              ListTile(
                onTap: () {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StudentHomeScreen(roll_no: widget.roll_no, password: widget.password)));
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              buildDivider(),
              const ListTile(
                leading: Icon(Icons.pin_end_rounded),
                title: Text("Enrollment"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentAttendanceScreen()));
                },
                leading: const Icon(Icons.co_present_outlined),
                title: const Text("Attendance"),
              ),
              buildDivider(),
              const ListTile(
                leading: Icon(Icons.more_time_sharp),
                title: Text("Surveys"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentGradesScreen()));
                },
                leading: const Icon(Icons.feed),
                title: const Text("Grades"),
              ),
              buildDivider(),
              const ListTile(
                leading: Icon(Icons.account_balance),
                title: Text("Accounts"),
              ),
              buildDivider(),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen(studentDataFromHome: studentData,)));
                },
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
              ),
              buildDivider(),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
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
      onChanged: (String? value) {}, // Modify onChanged function to handle changes
      value: null, // Ensure value is set to null
      autovalidateMode: AutovalidateMode.always, // Enable autovalidate mode
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

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
}



