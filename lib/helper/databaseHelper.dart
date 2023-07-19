import 'package:app_desafio/models/transacoes.dart';
import 'package:app_desafio/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper{
 static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();
  // {
  //    sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // } 

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async{
    //versao 1
    // String databasesPath = await databaseFactoryFfi.getDatabasesPath();
    // String path = join(databasesPath, 'banco.db');
    // DatabaseFactory databaseFactory = databaseFactoryFfi;
    // return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
    //           onCreate: _onCreate, version: 1));
    //versão 0
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'banco.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
      
  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account CHAR(5) NOT NULL,
        password CHAR(4) NOT NULL,
        perfil VARCHAR NOT NULL,
        saldo  REAL NOT NULL,
        UNIQUE(account)
      );
    ''');

    await db.execute('''
      CREATE TABLE transacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (userId) REFERENCES user(id)
      );
    ''');

    await db.execute('''
      INSERT INTO user (account,password,perfil,saldo )
      VALUES ('11111','1234','NORMAL',3000.0);
    ''');
    await db.execute('''
      INSERT INTO user (account,password,perfil,saldo )
      VALUES ('22222','1234','VIP',10000.0);
    ''');
  }

  Future<User?> getUser(String accountNumber) async{
    Database db = await _instance.database;
    List<Map<String, dynamic>> result = await db.query(
      User.tableName,
      where: 'account = ?',
      whereArgs: [accountNumber],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<double> getSaldoOfUser(String accountNumber) async{
    Database db = await _instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT saldo FROM user WHERE account = ?', [accountNumber]);
    if (result.isNotEmpty) {
      double saldo = result.first['saldo'];
      return saldo;
    }
    return 0.0;
  }

  Future<void> updateSaldoOfUser(String accountNumber,double newValue) async{
    Database db = await _instance.database;
    await db.update(
      User.tableName,
      {'saldo': newValue},
      where: 'account = ?',
      whereArgs: [accountNumber],
    );
    
  }

  Future<void> insertTransaccao(Transacoes novaTransacao) async{
    Database db = await _instance.database;
    await db.insert(
      Transacoes.tableName,
      novaTransacao.toMap()
    );
    print("FOI FEITO A TRANSACAÇAO");
  }

  Future<List<Transacoes>> gettingTransacoes(int id) async{
    Database db = await _instance.database;
    List<Map<String, dynamic>> result = await db.query(
      Transacoes.tableName,
      where: 'userId = ?',
      whereArgs: [id],
    );
    List<Transacoes> transacoes = result.map((map) => Transacoes.fromMap(map)).toList();
    print("CARREGOU AS TRANSAÇÕES");
    return transacoes;
  }

} 