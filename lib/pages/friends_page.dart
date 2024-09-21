import 'package:flutter/material.dart';
import 'package:pookiedex_connect/database_helper.dart';

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
                    onTap: () {
                      // Navigate to the friend's profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendProfilePage(friend: friend),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class FriendProfilePage extends StatelessWidget {
  final Map<String, dynamic> friend;

  const FriendProfilePage({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${friend['name']}\'s Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Text(
                  friend['name'].substring(0, 1), // Initial of the friend's name
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${friend['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Reg No: ${friend['reg_number']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Instagram: ${friend['insta_id']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Bio: ${friend['bio'] ?? 'No bio available'}', // Assuming 'bio' is stored, if not, use a placeholder
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
