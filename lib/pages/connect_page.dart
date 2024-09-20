import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:pookiedex_connect/database_helper.dart';

class ConnectPage extends StatefulWidget {
  final String qrData;
  ConnectPage({required this.qrData});

  @override
  _ConnectPageState createState() => _ConnectPageState();
}



class _ConnectPageState extends State<ConnectPage> {
    String scannedData = '';
  // final String qrData;

  // ConnectPage({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect"),
        backgroundColor: Color.fromARGB(255, 207, 85, 85),
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
                if (qrCode != '-1') {
                  // Directory appDocDir = await getApplicationDocumentsDirectory();
                  // String appDocPath = appDocDir.path;
                  // File file = File('$appDocPath/friends.csv');
                  // await file.writeAsString('$scanResult\n', mode: FileMode.append);
                  // print(scanResult);
                  List<String> qrFields = qrCode.split(",");

        if (qrFields.length == 3) {
          String name = qrFields[0];
          String regNumber = qrFields[1];
          String instaID = qrFields[2];

          // Insert scanned data into friends table
          DatabaseHelper dbHelper = DatabaseHelper();
          await dbHelper.insertFriend(name, regNumber, instaID);

          setState(() {
            scannedData = qrCode;
          });

          // Optionally, show a confirmation message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR data saved to friends list!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid QR code format!')),
          );
        }}
      

              
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