import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_data.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE,
        value TEXT
      )
    ''');

    // Table for QR data
    // await db.execute('''
    //   CREATE TABLE qr_data(
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     name TEXT,
    //     reg_number TEXT,
    //     insta_id TEXT
    //   )
    // ''');
      await db.execute('''
    CREATE TABLE qr_data(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      emailID TEXT,
      name TEXT,
      reg_number TEXT,
      insta_id TEXT,
      bio TEXT
    )
  ''');

    // New table for Friends
    await db.execute('''
      CREATE TABLE friends(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        reg_number TEXT,
        insta_id TEXT,
        bio TEXT,
        note TEXT,
        email TEXT
      )
    ''');
        // Insert sample data for first-time setup
    await db.insert(
      'friends',
      {
        'name': 'Rahul',
        'reg_number': '2XXXXXXXX',
        'insta_id': 'goated',
        'bio':'You will never know the lore',
        'note':'Legendary',
        'email':'smt@example.com'
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'friends',
      {
        'name': 'Emily',
        'reg_number': '2XXXXXXXX',
        'insta_id': 'goated',
        'bio':'You will never know the lore',
        'note':'Legendary',
        'email':'smt@example.com'
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // Future<void>insertQRData(String name, String regNumber, String instaID) async {
  //   final db = await database;
  //   await db.insert(
  //     'qr_data',
  //     {
  //       'name': name,
  //       'reg_number': regNumber,
  //       'insta_id': instaID
  //     },
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
    Future<void> insertQRData(String name, String regNumber, String instaID, String bio, String emailID, {String note = ""}) async {
    final db = await database;
      try {
    await db.insert(
      'friends',
      {
        'name': name,
        'reg_number': regNumber,
        'insta_id': instaID,
        'bio': bio,
        'note': note,
        'email': emailID,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces existing entry if same email exists
    );
    print("Data successfully inserted into SQLite");
  } catch (e) {
    print("Error inserting data into SQLite: $e");
  }
  }

  Future<void> updateNoteByEmail(String email, String note) async {
    final db = await database;
    try {
      await db.update(
        'friends',
        {'note': note},
        where: 'email = ?',
        whereArgs: [email],
      );
      print("Note successfully updated in SQLite");
    } catch (e) {
      print("Error updating note in SQLite: $e");
    }
  }
    Future<List<Map<String, dynamic>>> getQRData() async {
    final db = await database;
    return await db.query('qr_data');
  }
  Future<void> setSetupComplete(bool isComplete) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': 'isSetupComplete', 'value': isComplete ? 'true' : 'false'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

Future<bool> isSetupComplete() async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query(
    'settings',
    where: 'key = ?',
    whereArgs: ['isSetupComplete'],
  );
  if (result.isNotEmpty) {
    return result.first['value'] == 'true'; // Correct comparison to 'true'
  }
  return false; // Default to false if no data exists
}
// Fetch the first entry from the qr_data table (assuming there's only one record)
Future<Map<String, dynamic>?> getStoredQRData() async {
  final db = await database;
  List<Map<String, dynamic>> result = await db.query('qr_data');

  if (result.isNotEmpty) {
    return result.first; // Assuming only one entry in qr_data
  }
  return null; // No data stored yet
}
Future<int> updateQRData(String name, String regNumber, String instaID) async {
  final db = await database;

  // Delete the previous entry
  await db.delete('qr_data');

  // Insert new data (same as insertQRData)
  return await db.insert('qr_data', {
    'name': name,
    'reg_number': regNumber,
    'insta_id': instaID,
  });
}
// Insert QR data into the friends table
  Future<void> insertmyData(String email,String name, String regNumber, String instaID, String bio ) async {
    final db = await database;
      try {
    await db.insert(
      'qr_data',
      {
        'name': name,
        'reg_number': regNumber,
        'insta_id': instaID,
        'emailID': email,
        'bio':bio,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Replaces existing entry if same email exists
    );
    print("Data successfully inserted into SQLite");
  } catch (e) {
    print("Error inserting data into SQLite: $e");
  }
  }

  // Retrieve all friends from the friends table
  Future<List<Map<String, dynamic>>> getFriends() async {
    final db = await database;
    return await db.query('friends');
  }
  
  // Clear all friends from the friends table (optional)
  Future<void> clearFriends() async {
    final db = await database;
    await db.delete('friends');
  }
}
