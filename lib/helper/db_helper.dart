import 'dart:async';
import 'package:crud_sqflite/model/model_pegawai.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tablePegawai = 'noteTable';
  final String columnId = 'id';
  final String columnFirstName = 'firstname';
  final String columnLastName = 'lastname';
  final String columnMobileNo = 'mobileno';
  final String columnEmailId = 'emailid';

  static Database _db;
  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'pegawai.db');

    //await deleteDatabse (path) ;//just for testing
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablePegawai($columnId INTEGER PRIMARY KEY, $columnFirstName,$columnLastName TEXT, $columnMobileNo TEXT, $columnEmailId TEXT)');
  }

  Future<int> savePegawai(ModelPegawai pegawai) async {
    var dbClient = await db;
    var result = await dbClient.insert(tablePegawai, pegawai.toMap());

    return result;
  }

  Future<List> getAllPegawai() async {
    var dbClient = await db;
    var result = await dbClient.query(tablePegawai, columns: [
      columnId,
      columnFirstName,
      columnLastName,
      columnMobileNo,
      columnEmailId,
    ]);
    //var result = await dbClient.rawQerry('SELECT *FROM $tableNote);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT (*) FROM $tablePegawai'));
  }

  Future<int> deleteDataPegawai(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tablePegawai, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updatePegawai(ModelPegawai pegawai) async {
    var dbClient = await db;
    return await dbClient.update(tablePegawai, pegawai.toMap(),
        where: "$columnId=?", whereArgs: [pegawai.id]);
    //return await dbClient.rawUpdate(
    // 'UPDATE $tableNote SET $columnTitle=
    //\' ${note.title}\', $columnDescription =
    //'${note.description} \' WHERE $columnId = ${note.id};
    //
    //
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
