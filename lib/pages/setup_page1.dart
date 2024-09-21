import 'package:flutter/material.dart';
import 'package:pookiedex_connect/pages/setup_page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SetupPage1 extends StatefulWidget {
  @override
  _SetupPage1State createState() => _SetupPage1State();
}

class _SetupPage1State extends State<SetupPage1> {
  String emailID = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  
  bool _isAuthorized = false; // has granted permissions?
  final TextEditingController _controller = TextEditingController();
  static const List<String> scopes = <String>[
    'email',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign In With Google",
          onPressed: _handleSignIn,
        ),
      ),
    );
  }

  Widget _userInfo() {
    if (_user == null) return SizedBox();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (_user!.photoURL != null)
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_user!.photoURL!),
                ),
              ),
            ),
          if (_user!.email != null) Text(_user!.email!),
          if (_user!.displayName != null) Text(_user!.displayName!),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount? _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        String email = _currentUser.email;
        print(email);

        // Only allow email from @vitstudent.ac.in domain
        String checker = "@vitstudent.ac.in";
        if (!email.contains(checker)) {
          _auth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please use a valid VIT email")),
          );
        } else {
          _navigateToSetupPage2(email);
        }
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign in failed: $error")),
      );
    }
  }

  void _navigateToSetupPage2(String email) {
    setState(() {
      emailID = email;
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
        title: Text('Login with VIT Mail'),
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
              onPressed: () => _navigateToSetupPage2(_controller.text),
              child: Text('Next'),
            ),
            SizedBox(height: 20),
            _user != null ? _userInfo() : _googleSignInButton(),
          ],
        ),
      ),
    );
  }
}
