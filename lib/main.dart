/*import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model class for Friend
class Friend {
  final int? id;
  final String name;
  final String regNumber;
  final String instaId;

  Friend({this.id, required this.name, required this.regNumber, required this.instaId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'regNumber': regNumber,
      'instaId': instaId,
    };
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String qrData = "Sample QR Data from App State";

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      FriendsPage(),
      ConnectPage(qrData: qrData),
      SetupPage(onGenerateQR: (data) {
        setState(() {
          qrData = data;
        });
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Connect"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup"),
        ],
      ),
    );
  }
}

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friends")),
      body: Center(
        child: Text("List of Friends will be shown here"),
      ),
    );
  }
}

class ConnectPage extends StatelessWidget {
  final String qrData;

  ConnectPage({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connect")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
            data: qrData,
            size: 200,
            backgroundColor: Colors.white,
          ),
          ElevatedButton(
            onPressed: () async {
              String scanResult = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", true, ScanMode.QR);
              if (scanResult != '-1') {
                // Here you'd handle the QR scan result (parse and store it)
                print(scanResult);
              }
            },
            child: Text("Scan QR Code"),
          ),
        ],
      ),
    );
  }
}

class SetupPage extends StatefulWidget {
  final Function(String) onGenerateQR;

  SetupPage({required this.onGenerateQR});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regController = TextEditingController();
  final TextEditingController _instaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _regController,
              decoration: InputDecoration(labelText: "Registration Number"),
            ),
            TextField(
              controller: _instaController,
              decoration: InputDecoration(labelText: "Instagram ID"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String qrData =
                    "${_nameController.text},${_regController.text},${_instaController.text}";
                widget.onGenerateQR(qrData);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeDisplayPage(qrData: qrData),
                  ),
                );
              },
              child: Text("Generate QR"),
            ),
          ],
        ),
      ),
    );
  }
}

class QRCodeDisplayPage extends StatelessWidget {
  final String qrData;

  QRCodeDisplayPage({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your QR Code")),
      body: Center(
        child: QrImageView(
          data: qrData,
          size: 200,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pookiedex_connect/pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(), //just
    );
  }
}
