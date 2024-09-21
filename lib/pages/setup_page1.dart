import 'package:flutter/material.dart';
import 'package:pookiedex_connect/pages/setup_page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SetupPage1 extends StatefulWidget {
  @override
  _SetupPage1State createState() => _SetupPage1State();
}

class _SetupPage1State extends State<SetupPage1> {
  String emailID = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  final TextEditingController _controller = TextEditingController();
  
  Widget _googleSignInButton() {
    return Center(
        child: SizedBox(
            height: 50,
            child: SignInButton(Buttons.google,
                text: "Sign In With Google", onPressed: _handleGoogleSignIn)));
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(_user!.photoURL!))),
          ),
          Text(_user!.email!),
          Text(_user!.displayName!),
        ],
      ),
    );
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
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
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
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
            _user != null ? _userInfo() : _googleSignInButton(),

          ],
        ),
      ),
    );
  }
}