import 'package:flutter/material.dart';
import 'package:pookiedex_connect/pages/home_page.dart';
import 'package:pookiedex_connect/pages/setup_page1.dart';
import 'package:pookiedex_connect/database_helper.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:pookiedex_connect/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: 'AIzaSyDhg6Kt2K_p9ThTMvbezi7Wa2JZ9xo-vw8');
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//       debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Color.fromARGB(255, 243, 157, 157),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  // Set the overall scaffold background color
  scaffoldBackgroundColor: Color.fromARGB(255, 246, 169, 169),

  // Configure AppBar theme separately
  appBarTheme: AppBarTheme(
    color: Color.fromARGB(255, 33, 150, 243), // AppBar background color
    elevation: 4, // Shadow beneath the AppBar
    titleTextStyle: TextStyle(
      color: Colors.white, // AppBar title text color
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white, // Icon color for AppBar
    ),
  ),

  // Configure BottomNavigationBar theme separately
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 255, 82, 82), // BottomNavbar background color
    selectedItemColor: Color.fromARGB(255, 255, 255, 255), // Selected item color
    unselectedItemColor: Color.fromARGB(255, 0, 0, 0), // Unselected item color
    selectedIconTheme: IconThemeData(
      size: 30, // Selected icon size
    ),
    unselectedIconTheme: IconThemeData(
      size: 24, // Unselected icon size
    ),
    elevation: 8, // Shadow beneath BottomNavigationBar
  ),

  // Configure Card theme separately
  cardTheme: CardTheme(
    color: Color.fromARGB(255, 218, 210, 210), // Card background color
    elevation: 6, // Card shadow elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Card corner radius
    ),
  ),

  // Set other components' colors as needed
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Color.fromARGB(255, 33, 150, 243), // Primary color
    secondary: Color.fromARGB(255, 255, 87, 34), // Accent/Secondary color
  ),
)
,
      title: 'PookieDex',
      // theme: FlexThemeData.dark(scheme: FlexScheme.indigo),
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
