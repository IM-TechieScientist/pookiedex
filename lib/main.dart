import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:pookiedex_connect/models.dart';
import 'package:pookiedex_connect/pages/home_page.dart';
import 'package:pookiedex_connect/pages/setup_page1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:pookiedex_connect/database_helper.dart';
void main() {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Color.fromARGB(255, 243, 157, 157),
//       ),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conditional Navigation App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: _checkSetupStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData && snapshot.data == true) {
            // Setup is complete, so now fetch the QR data
            return FutureBuilder<Map<String, dynamic>?>(
              future: DatabaseHelper().getStoredQRData(),
              builder: (context, qrSnapshot) {
                if (qrSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                if (qrSnapshot.hasData && qrSnapshot.data != null) {
                  // Extract the stored QR data (name, reg_number, insta_id)
                  String name = qrSnapshot.data!['name'];
                  String regNumber = qrSnapshot.data!['reg_number'];
                  String instaID = qrSnapshot.data!['insta_id'];

                  String qrData = "$name,$regNumber,$instaID";
                  return HomePage(qrData: qrData);
                } else {
                  return SetupPage1(); // If no QR data is found, fall back to setup
                }
              },
            );
          } else {
            return SetupPage1(); // If setup isn't complete, go to setup page
          }
        },
      ),
    );
  }

  Future<bool> _checkSetupStatus() async {
    return await DatabaseHelper().isSetupComplete();
  }
}
