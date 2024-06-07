import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:portal/Admin/Admin_Home/Admin_Activities/edit_class.dart';

class ManageClassesScreen extends StatefulWidget {
  const ManageClassesScreen({Key? key}) : super(key: key);

  @override
  State<ManageClassesScreen> createState() => _ManageClassesScreenState();
}

class _ManageClassesScreenState extends State<ManageClassesScreen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Classroom");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        title: const Text("Manage Classes", style: TextStyle(color: Colors.white)),
      ),
      body: FirebaseAnimatedList(
        query: ref,
        itemBuilder: (context, classSnapshot, classAnimation, classIndex) {
          String className = classSnapshot.key ?? 'No Class Name';

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade200,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Class: $className",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: ref.child(className),
                  itemBuilder: (context, sectionSnapshot, sectionAnimation, sectionIndex) {
                    String sectionName = sectionSnapshot.key ?? 'No Section Name';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text("Section: $sectionName"),
                        trailing: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditClassScreen(
                                  classs: className,
                                  section: sectionName,
                                ),
                              ),
                            );
                            // Refresh the screen when the user returns from the edit screen
                            setState(() {});
                          },
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.blueGrey.shade700,
    );
  }
}


// ListView.builder(
// itemCount: classList.length,
// itemBuilder: (context, index) {
// return Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// ListView.builder(
// shrinkWrap: true,
// physics: NeverScrollableScrollPhysics(),
// itemCount: sectionList.length,
// itemBuilder: (context, sectionIndex) {
// return Container(
// padding: EdgeInsets.only(right: 0,left: 15),
// margin: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
// decoration: BoxDecoration(
// color: Colors.blueGrey.shade100,
// borderRadius: BorderRadius.circular(10),
// boxShadow: const [
// BoxShadow(
// color: Colors.grey
// )
// ]
// ),
// child: ListTile(
// title: Text("${classList[index]}${sectionList[sectionIndex]}"),
// trailing: GestureDetector(
// onTap: (){
// Navigator.push(context, MaterialPageRoute(builder: (context)=>EditClassScreen(classs: classList[index].toString(),section: sectionList[sectionIndex].toString(),)));
// },
// child: Icon(Icons.edit)
// ),
// ),
// );
// },
// ),
// ],
// );
// },
// ),



// Widget buildDropdownButtonFormField(String labelText, List<String> items, ValueChanged<String?> onChanged) {
//   return DropdownButtonFormField<String>(
//     decoration: InputDecoration(
//       labelText: labelText,
//       contentPadding: const EdgeInsets.symmetric(vertical: 0),
//       prefixIcon: const Icon(Icons.person),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.green, width: 2.0),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//     items: items.map<DropdownMenuItem<String>>((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList(),
//     value: null,
//     onChanged: onChanged,
//   );
// }


// Container(
// margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// decoration: BoxDecoration(
// color: Colors.blueGrey.shade100,
// borderRadius: BorderRadius.circular(10),
// boxShadow: const [
// BoxShadow(
// color: Colors.white,
// blurRadius: 10,
// )
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.all(15),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// const Text(
// "Add Class",
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.w600,
// ),
// ),
// const SizedBox(height: 15),
// buildDropdownButtonFormField("Class", ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"], (value) {
// setState(() {
// selectedClass = value;
// });
// }),
// const SizedBox(height: 15),
// buildDropdownButtonFormField("Section", ["A", "B", "C", "D","E"], (value) {
// setState(() {
// selectedSection = value;
// });
// }),
// Padding(
// padding: const EdgeInsets.only(top: 10),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// CustomizedElevatedButton(
// text: "Add Class",
// onTap: addClassToDatabase,
// loading: loading,
// )
// ],
// ),
// )
// ],
// ),
// ),
// ),