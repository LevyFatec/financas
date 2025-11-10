import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'financeiro.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        valor REAL,
        tipo TEXT,
        categoria TEXT,
        formaPagamento TEXT,
        data TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categorias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        icone TEXT
      )
    ''');

    // Categorias padrão
    final categoriasPadrao = [
      ['Alimentação', '🍔'],
      ['Transporte', '🚗'],
      ['Lazer', '🎮'],
      ['Salário', '💰'],
      ['Saúde', '💊'],
      ['Outros', '📦']
    ];

    for (var cat in categoriasPadrao) {
      await db.insert('categorias', {'nome': cat[0], 'icone': cat[1]});
    }
  }
}
