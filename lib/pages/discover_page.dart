import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  // List of categories to display as buttons
  final List<Map<String, String>> categories = [
    {"title": "Gaming", "icon": "🎮"},
    {"title": "Coding", "icon": "💻"},
    {"title": "Trekking", "icon": "🏞"},
    {"title": "Cycling", "icon": "🚴‍♂️"},
    {"title": "Photography", "icon": "📷"},
    {"title": "Reading", "icon": "📚"},
    {"title": "Academics", "icon": "📖"},
    {"title": "Music", "icon": "🎵"},
    {"title": "Cooking", "icon": "🍳"},
    {"title": "Travelling", "icon": "✈️"},

    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Similar People'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // Adjust the number of items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,  // Adjust for the card size
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // Navigate to the list of names when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NamesListPage(category: category["title"]!),
                  ),
                );
              },
              child: Card(
                color: Colors.blueAccent.withOpacity(0.8), // Card background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category["icon"] ?? "",
                        style: TextStyle(fontSize: 32),  // Emoji size
                      ),
                      SizedBox(height: 8),
                      Text(
                        category["title"]!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NamesListPage extends StatelessWidget {
  final String category;

  // Dummy list of names for demonstration
  final Map<String, List<String>> categoryToNames = {
    "Gaming": ["John Doe", "Jane Smith", "Alex Johnson"],
    "Coding": ["Emily Davis", "Michael Brown", "Sarah Lee"],
    "Trekking": ["Chris Evans", "Natalie Portman", "Robert Downey"],
    "Cycling": ["Brie Larson", "Tom Holland", "Chris Hemsworth"],
    "Photography": ["Scarlett Johansson", "Mark Ruffalo", "Jeremy Renner"],
    "Reading": ["Tom Hiddleston", "Paul Rudd", "Elizabeth Olsen"],
    "Academics": ["Chadwick Boseman", "Benedict Cumberbatch", "Sebastian Stan"],
    "Music": ["Tom Holland", "Chris Hemsworth", "Brie Larson"],
    "Cooking": ["Scarlett Johansson", "Mark Ruffalo", "Jeremy Renner"],
    "Travelling": ["Tom Hiddleston", "Paul Rudd", "Elizabeth Olsen"],
    // Add more categories and corresponding names here
  };

  NamesListPage({required this.category});

  @override
  Widget build(BuildContext context) {
    List<String> names = categoryToNames[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Enthusiasts'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(names[index][0])),  // First letter of the name
            title: Text(names[index]),
          );
        },
      ),
    );
  }
}
