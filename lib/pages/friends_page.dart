import 'package:flutter/material.dart';
import 'package:pookiedex_connect/database_helper.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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
        title: Center(child: Text('Friends')),
      ),
      body: _friends.isEmpty
          ? Center(child: Text('You have no friends'))
          : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  child: ListTile(
                    title: Text(friend['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reg No: ${friend['reg_number']}'),
                          Text('Instagram: ${friend['insta_id']}'),
                        ],
                      ),
                    ),
                    onTap: () {
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

class FriendProfilePage extends StatefulWidget {
  final Map<String, dynamic> friend;
  FriendProfilePage({Key? key, required this.friend}) : super(key: key);

  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final gemini = Gemini.instance;
  String prompt = 'A person has sent me their bioinfo for a social media app, extrapolate points and summarize it into five keywords separated by commas. The bio is ';
  late Future<String> keywordsFuture;
  TextEditingController _noteController = TextEditingController();
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    keywordsFuture = generateKeywords();
  }

  Future<String> generateKeywords() async {
    try {
      final response = await gemini.text("$prompt ${widget.friend['bio']}");
      return response?.output ?? 'No keywords available';
    } catch (e) {
      return 'Error generating keywords';
    }
  }

  void _addNote() async {
    if (_noteController.text.isNotEmpty) {
      String note = _noteController.text;
      String email = widget.friend['email']; // Assuming email is a unique identifier for the friend

      // Call the database update function
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.updateNoteByEmail(email, note);

      setState(() {
        _notes.add(note);
        _noteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.friend['name']}\'s Profile'),
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
                  widget.friend['name'].substring(0, 1), // Initial of the friend's name
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                  '${widget.friend['name']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 1),
                Text(
                'Reg No: ${widget.friend['reg_number']}',
                style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                'Instagram: ${widget.friend['insta_id']}',
                style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                'Bio: ${widget.friend['bio'] ?? 'No bio available'}',
                style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
            FutureBuilder<String>(
              future: keywordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error generating keywords');
                } else {
                  return Text(
                    'Keywords: ${snapshot.data ?? 'No keywords available'}',
                  );
                }
              },
            ),
              ],
              ),
            ),
            
            SizedBox(height: 20),

            // TextField for note-taking
            FutureBuilder<String?>(
              future: Future.value(widget.friend['note']),
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                _noteController.text = snapshot.data ?? '';
                return TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Edit note',
                  border: OutlineInputBorder(),
                ),
                );
              }
              },
            ),
            SizedBox(height: 10),

            // Button to add note
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Save Note'),
            ),

            // Display list of notes
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.note),
                    title: Text(_notes[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
