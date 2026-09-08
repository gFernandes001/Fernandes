import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'tarefas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tarefas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT)',
        );
      },
    );
  }

  Future<int> insertTarefa(String titulo) async {
    Database dbClient = await db;
    return await dbClient.insert('tarefas', {'titulo': titulo});
  }

  Future<List<Map<String, dynamic>>> getTarefas() async {
    Database dbClient = await db;
    return await dbClient.query('tarefas');
  }

  
  Future<int> deleteAll() async {
    Database dbClient = await db;
    return await dbClient.delete('tarefas');
  }

  
  Future<List<Map<String, dynamic>>> buscarPorTexto(String texto) async {
    Database dbClient = await db;
    return await dbClient.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%$texto%'],
    );
  }
}