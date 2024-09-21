import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:pookiedex_connect/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectPage extends StatefulWidget {
  final String qrData;
  ConnectPage({required this.qrData});

  @override
  _ConnectPageState createState() => _ConnectPageState();
}



class _ConnectPageState extends State<ConnectPage> {
    String scannedData = '';
  // final String qrData;

  Future<void> fetchUserDetailsFromFirebase(String emailID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');
    DocumentSnapshot<Map<String, dynamic>> userDoc = await usersCollection.doc(emailID).get();
    print("User Doc: $userDoc emailID: $emailID");
    if (userDoc.exists) {
      // Assuming the fields in Firestore are: name, registration_number, instaID
      String name = userDoc.get('name');
      String regNumber = userDoc.get('registration_number');
      String instaID = userDoc.get('instaID');
      String bio=userDoc.get("bio");

      // Save these details to SQLite
      await DatabaseHelper().insertQRData(name, regNumber, instaID,bio,widget.qrData);

      print("User Data saved locally: Name: $name, Reg Number: $regNumber, InstaID: $instaID");
                // Optionally, show a confirmation message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR data saved to friends list!')),
          );
    } else {
      print("User not found in Firebase.");
                ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid QR code format!')),
          );
    }
  }
  // ConnectPage({required this.qrData});

  @override
  Widget build(BuildContext context) {
    String _qrCode='';
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect"),
        // backgroundColor: Color.fromARGB(255, 207, 85, 85),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Scan QR Code"),
              onPressed: () async {
                String qrCode = await FlutterBarcodeScanner.scanBarcode(
                    "#ff6666", "Cancel", true, ScanMode.QR);
        //         if (qrCode != '-1') {
        //           // Directory appDocDir = await getApplicationDocumentsDirectory();
        //           // String appDocPath = appDocDir.path;
        //           // File file = File('$appDocPath/friends.csv');
        //           // await file.writeAsString('$scanResult\n', mode: FileMode.append);
        //           // print(scanResult);
        //           List<String> qrFields = qrCode.split(",");

        // if (qrFields.length == 3) {
        //   String name = qrFields[0];
        //   String regNumber = qrFields[1];
        //   String instaID = qrFields[2];

        //   // Insert scanned data into friends table
        //   DatabaseHelper dbHelper = DatabaseHelper();
        //   await dbHelper.insertFriend(name, regNumber, instaID);

        //   setState(() {
        //     scannedData = qrCode;
        //   });


        // } else {

        // }}
        
            if (qrCode != '-1') {  // If not canceled
      setState(() {
        _qrCode = qrCode; // This is the emailID now
      });

      // Fetch user details from Firebase using emailID
      await fetchUserDetailsFromFirebase(qrCode);
    }
      

              
  }),
            SizedBox(height: 20),
            QrImageView(
              data: widget.qrData.isNotEmpty ? widget.qrData : "No QR data available",
              size: 200,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}