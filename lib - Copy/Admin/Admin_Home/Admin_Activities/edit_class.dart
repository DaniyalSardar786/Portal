import 'package:flutter/material.dart';
import 'package:portal/Others/elevated_button.dart';

class EditClassScreen extends StatefulWidget {
  const EditClassScreen({super.key});

  @override
  State<EditClassScreen> createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final bool loading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this color to whatever you want
          ),
          backgroundColor: Colors.transparent,
          title: const Text("Edit Class", style: TextStyle(color: Colors.white)),
          bottom: const TabBar(
            tabs: [
              Icon(Icons.menu_book, color: Colors.white, size: 30),
              Icon(Icons.perm_identity, color: Colors.white, size: 30)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
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
                        mainAxisSize: MainAxisSize.min, // Minimize the size of the column
                        children: [
                          const Text(
                            "Add Subject",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildDropdownButtonFormField("Select Subject", ["A", "B", "C"]),
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomizedElevatedButton(
                                    text: "Add Subject", onTap: () {}, loading: loading)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: 10,
                    physics: NeverScrollableScrollPhysics(), // Prevent ListView from scrolling
                    shrinkWrap: true, // Make ListView take only the necessary space
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const ListTile(
                            title: Text("Subject"),
                            subtitle: Text("Subject Id"),
                            trailing: Icon(Icons.delete)
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
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
                        mainAxisSize: MainAxisSize.min, // Minimize the size of the column
                        children: [
                          const Text(
                            "Add Student",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildDropdownButtonFormField("Select Student", ["12157","12143","12142"]),
                          Padding(
                            padding: EdgeInsets.only(top: 12, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomizedElevatedButton(
                                    text: "Add Student", onTap: () {}, loading: loading)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: 10,
                    physics: NeverScrollableScrollPhysics(), // Prevent ListView from scrolling
                    shrinkWrap: true, // Make ListView take only the necessary space
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const ListTile(
                              title: Text("12157"),
                              subtitle: Text("BSCS 4A"),
                              trailing: Icon(Icons.delete)
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey.shade700,
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
      }).toList(),
      value: null,
      onChanged: (String? value) {},
    );
  }
}
