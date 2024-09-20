import 'package:flutter/material.dart';
import 'package:pookiedex_connect/pages/setup_page2.dart';

class SetupPage1 extends StatefulWidget {
  @override
  _SetupPage1State createState() => _SetupPage1State();
}

class _SetupPage1State extends State<SetupPage1> {
  String emailID = '';
  final TextEditingController _controller = TextEditingController();

  void _navigateToSetupPage2() {
    setState(() {
      emailID = _controller.text;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetupPage(emailID: emailID)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Page 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToSetupPage2,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}