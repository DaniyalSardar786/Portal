import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portal/Login/login.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


/// To-Do
/// 1: Complete student related things from admin side .....26-5-2024
/// 2: Manage Classes..............27-5-2024
/// 3: Manage Subjects.............28-5-2024
/// 4: Add faculty thing...........29-5-2024
/// 5: Faculty related things........30-5-2024
/// 6: Mark attendance................31-5-2024
/// 7: Manage Marks...................1-6-2024
/// 8: Manage my_classes..............2-6-2024
/// 9: Manage Faculty.................3-6-2024
/// 10: Upload Pictures..............4-6-2024
/// 11: View Attendance..............5-6-2024
/// 12: View Grades..................6-6-2024
/// 13: UI Design....................7-6-2024
/// Around 20 Days...................Expected completed date 16 June 2024

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

