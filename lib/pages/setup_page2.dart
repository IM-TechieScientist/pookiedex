import 'package:flutter/material.dart';
import 'package:pookiedex_connect/pages/connect_page.dart';
import 'package:pookiedex_connect/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pookiedex_connect/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SetupPage extends StatefulWidget {
  final String emailID;

  SetupPage({required this.emailID});
  // SetupPage();

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
      appBar: AppBar(
        title: Text("Setup"),
        backgroundColor: Color.fromARGB(255, 207, 85, 85),
      ),
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
              onPressed: () async {
                FocusScope.of(context).unfocus();

                String qrData =
                    "${_nameController.text},${_regController.text},${_instaController.text}";
                setState(() {
                  qrData="${_nameController.text},${_regController.text},${_instaController.text}";

                });
                  DatabaseHelper dbHelper = DatabaseHelper();
                  if (await dbHelper.isSetupComplete() == true){
                  dbHelper.updateQRData(_nameController.text, _regController.text, _instaController.text);
                  } else{
                  dbHelper.insertQRData(_nameController.text, _regController.text, _instaController.text);

                  // Mark the setup as complete
                  dbHelper.setSetupComplete(true);}
                // DatabaseHelper dbHelper = DatabaseHelper();
                // dbHelper.insertQRData(_nameController.text,_regController.text,_instaController.text);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ConnectPage(qrData: qrData),
                //   ),
                // );
                Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(qrData: qrData,)),
    );
                // widget.onGenerateQR(qrData);
                ConnectPage(qrData: qrData);
              },
              child: Text("Save Data"),
            ),
          ],
        ),
      ),
    );
  
  // Future<void> _completeSetup() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool('isSetupComplete', true);

  // Future<void> _saveQRData(String qrData) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/qrdata.txt');
  //   await file.writeAsString(qrData);
  // }

  // await _saveQRData("${_nameController.text},${_regController.text},${_instaController.text}");
  // Navigator.pushReplacementNamed(context, '/home_page');
 }
}