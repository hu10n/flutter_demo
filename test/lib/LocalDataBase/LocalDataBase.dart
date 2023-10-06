import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test/api/api.dart';

class DatabaseHelper {
  static final _dbName = 'Database.db';
  static final _dbVersion = 3;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE machine (
        machine_id TEXT PRIMARY KEY,
        machine_group TEXT NOT NULL,
        machine_num INTEGER NOT NULL,
        machine_name TEXT NOT NULL,
        machine_status INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE project (
        project_id TEXT PRIMARY KEY,
        project_status INTEGER NOT NULL,
        client_name TEXT,
        product_name TEXT,
        product_num TEXT,
        material TEXT,
        lot_num TEXT,
        supervisor TEXT,
        production_volume INTEGER,
        cycle_time INTEGER,
        box_sequence INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        machine_id TEXT REFERENCES machine(machine_id),
        FOREIGN KEY (machine_id) REFERENCES machine(machine_id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE step (
        step_id TEXT PRIMARY KEY,
        step_name TEXT,
        finished_at TEXT,
        started_at TEXT,
        project_status INTEGER NOT NULL,
        worker TEXT,
        free_text TEXT,
        step_num INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        project_id TEXT REFERENCES project(project_id),
        FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE
      )
    ''');
  }

  //ほぼデバッグ用-----------------------------------------------------------
  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(
      tableName,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //途中でカラムを追加する場合。普通にdbを作成し直した方がいい。
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion < 3){
      print("object");
      await db.execute("ALTER TABLE step ADD COLUMN production_volume INTEGER");
    }
  }
  //-----------------------------------------------------------------------

  //指定したテーブルの全レコード取得--------------------------------------------
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await instance.database;
    //print(db);
    return await db.query(tableName);
  }
  //-----------------------------------------------------------------------

  //RDSからデータを取得し、LDBを更新。
  Future<void> update(bool isAll) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('last_updated') ??
        "0001-01-01T00:00:00Z"; // int値の取得、値がない場合は0001~を返す
    final result;

    if(isAll){
      result = await getAllDataGrobal(); //全データを更新
    }else{
      result = await postJSONData(value); //新しいデータのみ更新
    }
    //print(result);
    Database db = await instance.database;

    for (var row in result["machine"]) {
      await db.insert(
        "machine",
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    for (var row in result["project"]) {
      await db.insert(
        "project",
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    for (var row in result["step"]) {
      await db.insert(
        "step",
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await prefs.setString('last_updated', result["current"]); // int値の保存
  }

  //完了済プロジェクトの削除に使用。プロジェクトを消せば、関連するステップも自動削除。---
  Future<void> delete(String id,String table) async {
    //print(id);
    Database db = await instance.database;
    await db.delete(table, where: '${table}_id = ?', whereArgs: [id]);
  }
  //-----------------------------------------------------------------------
  //LDB削除-----------------------------------------------------------------
  Future<void> delete_database() async {
    String path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);
    _database = null; // _database のリファレンスを削除
  }
  //-----------------------------------------------------------------------
}

