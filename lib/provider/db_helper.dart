import 'package:attendance/model/history.dart';
import 'package:attendance/provider/db_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  // ignore: sort_constructors_first
  factory DBHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    // ignore: join_return_with_assignment
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.toString(), 'main.db');
    final theDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          create table ${DBConstants.historyTable} (
          ${DBConstants.columnID} integer primary key autoincrement,
          ${DBConstants.columnDate} text,
          ${DBConstants.columnPinLocation} text,
          ${DBConstants.columnUserLocation} text,
          ${DBConstants.columnDistance} real)
          ''',
        );
      },
    );
    return theDb;
  }

  // ignore: sort_constructors_first
  DBHelper.internal();

  //
  // HISTORY
  //
  Future<void> insertHistory(History history) async {
    final dbClient = await db;

    await dbClient!.insert(
      DBConstants.historyTable,
      history.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<History>> getListHistory() async {
    final dbClient = await db;

    final maps = await dbClient!.query(
      DBConstants.historyTable,
      orderBy: '${DBConstants.columnID} DESC',
    );
    if (maps.isNotEmpty) {
      return List<dynamic>.from(maps)
          .map((dynamic e) => History.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future close() async {
    final dbClient = await db;
    await dbClient!.close();
  }
}
