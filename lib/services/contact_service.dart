import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:contact/models/contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'contacts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, email TEXT, organization TEXT, isFavorite INTEGER)',
        );
      },
      version: 2, // Increment the version number
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute(
              'ALTER TABLE contacts ADD COLUMN isFavorite INTEGER DEFAULT 0');
        }
      },
    );
  }

  static Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      orderBy: 'name ASC', // Add this line to sort by name
    );
    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      map['isFavorite'] = map['isFavorite'] == 1;
      return Contact.fromMap(map);
    });
  }

  static Future<void> addContact(Contact contact) async {
    final db = await database;
    await db.insert(
      'contacts',
      contact.toMap()..['isFavorite'] = contact.isFavorite ? 1 : 0,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateContact(Contact contact) async {
    final db = await database;
    await db.update(
      'contacts',
      contact.toMap()..['isFavorite'] = contact.isFavorite ? 1 : 0,
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  static Future<void> deleteContact(int id) async {
    final db = await database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> redirectToWhatsApp(String phone) async {
    final formattedPhone = '62${phone.substring(1)}';
    final url = 'https://api.whatsapp.com/send/?phone=$formattedPhone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
