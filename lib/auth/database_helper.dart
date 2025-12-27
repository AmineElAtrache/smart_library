import 'package:smart_library/models/books_model.dart';
import 'package:smart_library/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  final databaseName = "books.db";

  //Tables

  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT UNIQUE, 
   usrPassword TEXT
   )
   ''';

     String mybooks = '''
   CREATE TABLE mybooks (
    id TEXT,
    usrId INTEGER,
    title TEXT,
    authors TEXT,
    thumbnail TEXT,
    description TEXT,
    category TEXT,
    status TEXT,
    pages INTEGER,
    PRIMARY KEY (id, usrId),
    FOREIGN KEY (usrId) REFERENCES users(usrId)
   )
   ''';

  String favorites = '''
    CREATE TABLE favorites (
      id TEXT,
      usrId INTEGER,
      title TEXT,
      authors TEXT,
      thumbnail TEXT,
      description TEXT,
      category TEXT,
      status TEXT,
      pages INTEGER,
      PRIMARY KEY (id, usrId),
      FOREIGN KEY (usrId) REFERENCES users(usrId)
    )
  ''';

 String reading_history = '''
   CREATE TABLE reading_history (
   id	INTEGER	PRIMARY	KEY AUTOINCREMENT,
   bookId	TEXT,
   usrId INTEGER,
   startDate	TEXT,
   endDate	TEXT,
   status	TEXT,
   FOREIGN KEY (usrId) REFERENCES users(usrId)
   )
   ''';
   
   String notes = '''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usrId INTEGER,
      bookId TEXT,
      content TEXT,
      createdAt TEXT,
      FOREIGN KEY (usrId) REFERENCES users(usrId)
    )
   ''';

   // New Table for tracking daily page progress
   String daily_reading_log = '''
    CREATE TABLE daily_reading_log (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usrId INTEGER,
      bookId TEXT,
      pagesRead INTEGER,
      logDate TEXT,
      FOREIGN KEY (usrId) REFERENCES users(usrId)
    )
   ''';


  //Create a connection to the database
  Future<Database> initDB ()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path,version: 4 , 
    onCreate: (db,version)async{
      await db.execute(user);
      await db.execute(favorites);
      await db.execute(mybooks);
      await db.execute(reading_history);
      await db.execute(notes);
      await db.execute(daily_reading_log);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
           try {
             await db.execute("ALTER TABLE favorites ADD COLUMN category TEXT DEFAULT 'General'");
             await db.execute("ALTER TABLE favorites ADD COLUMN status TEXT DEFAULT 'Not Read'");
             await db.execute("ALTER TABLE favorites ADD COLUMN pages INTEGER DEFAULT 0");

             await db.execute("ALTER TABLE mybooks ADD COLUMN category TEXT DEFAULT 'General'");
             await db.execute("ALTER TABLE mybooks ADD COLUMN status TEXT DEFAULT 'Not Read'");
             await db.execute("ALTER TABLE mybooks ADD COLUMN pages INTEGER DEFAULT 0");
             
             await db.execute(reading_history);
             await db.execute(notes);
           } catch (e) {
             print("Migration error (ignored if columns exist): $e");
           }
        }
        if (oldVersion < 4) {
          try {
            await db.execute(daily_reading_log);
          } catch (e) {
             print("Migration error v4: $e");
          }
        }
      },
    );
  }

  //Function

  //Authentication
  Future<bool> authenticate(Users usr)async{
    final Database db = await initDB();
    var result = await db.rawQuery("select * from users where email = '${usr.email}' AND usrPassword = '${usr.password}' ");
    if(result.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  //Sign up
  Future<int> createUser(Users usr)async{
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }


  //Get current User details
  Future<Users?> getUser(String email)async{
    final Database db = await initDB();
    var res = await db.query("users",where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty? Users.fromMap(res.first):null;
  }

  // Insert a book into favorites
  Future<int> insertFavorite(Book book, int usrId) async {
    final Database db = await initDB();
    
    final Map<String, dynamic> bookMap = {
      'id': book.id,
      'title': book.title,
      'authors': book.authors.map((author) => author.toString()).join(', '),
      'thumbnail': book.thumbnail,
      'description': book.description,
      'category': book.category,
      'status': book.status,
      'pages': book.pages,
      'usrId': usrId,
    };

    return db.insert("favorites", bookMap,
    conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a book from favorites by its id
  Future<int> removeFavorite(String id, int usrId) async {
    final Database db = await initDB();
    return db.delete("favorites", where: "id = ? AND usrId = ?", whereArgs: [id, usrId],
    );
  }

  // Retrieve all favorite books
  Future<List<Book>> getFavorites(int usrId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "favorites",
      where: "usrId = ?",
      whereArgs: [usrId],
    );

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        authors: maps[i]['authors'].toString().split(', '),
        thumbnail: maps[i]['thumbnail'],
        description: maps[i]['description'],
        category: maps[i]['category'] ?? 'General',
        status: maps[i]['status'] ?? 'Not Read',
        pages: maps[i]['pages'] ?? 0,
      );
    });
  }


  Future<List<Book>> getUserBooks(int usrId) async {
  final Database db = await initDB();
  final List<Map<String, dynamic>> maps = await db.query(
    "mybooks",
    where: "usrId = ?",
    whereArgs: [usrId],
  );

  return List.generate(maps.length, (i) {
    return Book(
      id: maps[i]['id'],
      title: maps[i]['title'],
      authors: maps[i]['authors'].toString().split(', '),
      thumbnail: maps[i]['thumbnail'],
      description: maps[i]['description'],
      category: maps[i]['category'] ?? 'General',
      status: maps[i]['status'] ?? 'Not Read',
      pages: maps[i]['pages'] ?? 0,
    );
  });
}

Future<int> insertUserBook(Book book, int usrId) async {
  final Database db = await initDB();
    final Map<String, dynamic> bookMap = {
      'id': book.id,
      'title': book.title,
      'authors': book.authors.map((author) => author.toString()).join(', '),
      'thumbnail': book.thumbnail,
      'description': book.description,
      'category': book.category,
      'status': book.status,
      'pages': book.pages,
      'usrId': usrId,
    };

  return db.insert(
    "mybooks",
    bookMap,
    conflictAlgorithm: ConflictAlgorithm.replace, 
  );
}

Future<int> removeUserBook(String id, int usrId) async {
  final Database db = await initDB();
  return db.delete(
    "mybooks",
    where: "id = ? AND usrId = ?",
    whereArgs: [id, usrId],
  );
}

// === Reading History Methods ===

  Future<List<Map<String, dynamic>>> getReadingHistory(int usrId) async {
    final Database db = await initDB();
    return await db.query("reading_history", where: "usrId = ?", whereArgs: [usrId]);
  }

  Future<void> updateReadingHistory(String bookId, int usrId, String status) async {
     final Database db = await initDB();
     await db.insert("reading_history", {
       "bookId": bookId,
       "usrId": usrId,
       "startDate": DateTime.now().toIso8601String(),
       "status": status,
     });
  }

  // === Progress & State Methods ===

  // Updated to track daily progress delta
  Future<void> updatePageProgress(String bookId, int usrId, int newPage) async {
     final Database db = await initDB();
     
     // 1. Get current pages to calculate delta
     var res = await db.query("mybooks", columns: ['pages'], where: "id = ? AND usrId = ?", whereArgs: [bookId, usrId]);
     int currentPages = 0;
     if (res.isNotEmpty && res.first['pages'] != null) {
       currentPages = res.first['pages'] as int;
     }

     int delta = newPage - currentPages;

     // 2. Log if positive progress (we ignore rewinds for the monthly goal to avoid cheating? or allow corrections? 
     // Let's assume positive progress counts towards goal. Correcting downwards doesn't remove from "effort" technically but for stats it might be tricky.
     // For simplicity: log positive delta.)
     if (delta > 0) {
       await db.insert("daily_reading_log", {
         "usrId": usrId,
         "bookId": bookId,
         "pagesRead": delta,
         "logDate": DateTime.now().toIso8601String(),
       });
     }

     await db.update("mybooks", {"pages": newPage}, where: "id = ? AND usrId = ?", whereArgs: [bookId, usrId]);
  }
  
  // New method to get monthly progress
  Future<int> getPagesReadThisMonth(int usrId) async {
    final Database db = await initDB();
    final now = DateTime.now();
    // ISO8601 string sortable: yyyy-MM-01
    final startOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
    
    final result = await db.rawQuery('''
      SELECT SUM(pagesRead) as total 
      FROM daily_reading_log 
      WHERE usrId = ? AND logDate >= ?
    ''', [usrId, startOfMonth]);
    
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  Future<void> updateBookState(String bookId, int usrId, String status) async {
    final Database db = await initDB();
    await db.update("mybooks", {"status": status}, where: "id = ? AND usrId = ?", whereArgs: [bookId, usrId]);
  }

  // === Notes Methods ===

  Future<List<Map<String, dynamic>>> getNotes(int usrId) async {
     final Database db = await initDB();
     return await db.query("notes", where: "usrId = ?", whereArgs: [usrId]);
  }

  Future<int> insertNote(Map<String, dynamic> note) async {
     final Database db = await initDB();
     return await db.insert("notes", note);
  }

  Future<int> deleteNote(int id) async {
     final Database db = await initDB();
     return await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }


Future<void> deleteTable(String tableName) async {
  try {
    final Database db = await initDB();
    await db.execute("DROP TABLE IF EXISTS $tableName");
    print("Table $tableName deleted successfully.");
  } catch (e) {
    print("Error deleting table $tableName: $e");
  }
}
}