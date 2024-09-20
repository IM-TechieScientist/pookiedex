import 'package:flutter/material.dart';
import 'package:pookiedex_connect/database_helper.dart';

// class FriendsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Friends"),
//         backgroundColor: Color.fromARGB(255, 207, 85, 85),
//       ),
//       body: Center(
//         child: Text("You have no friends"),
//       ),
//     );
//   }
// }


class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> friendsList = await dbHelper.getFriends();
    setState(() {
      _friends = friendsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: _friends.isEmpty
          ? Center(child: Text('You have no friends'))
          : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(friend['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reg No: ${friend['reg_number']}'),
                        Text('Instagram: ${friend['insta_id']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
