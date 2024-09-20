import 'package:flutter/material.dart';
import 'package:pookiedex_connect/pages/friends_page.dart';
import 'package:pookiedex_connect/pages/connect_page.dart';
import 'package:pookiedex_connect/pages/setup_page1.dart';

class HomePage extends StatefulWidget {
  final String qrData;

  HomePage({required this.qrData});
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      FriendsPage(),
      ConnectPage(qrData: widget.qrData),
      // SetupPage(onGenerateQR: (data) {
      //   setState(() {
      //     qrData = data;
      //     // Refresh the ConnectPage with the new QR data
      //     _pages[1] = ConnectPage(qrData: qrData);
      //   });
      // }),
      SetupPage1(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 207, 85, 85),
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
