import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../model/alarm.dart';

const String databaseName = 'alarm.db';
const String tableName = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnIsPending = 'isPending';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;
  AlarmHelper._createInstance();

  factory AlarmHelper() {
    _alarmHelper ??= _alarmHelper = AlarmHelper._createInstance();
    return _alarmHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + databaseName;
    var database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
            create table $tableName (
            $columnId integer primary key autoincrement,
            $columnIsPending text not null,
            $columnTitle text not null,
            $columnDateTime text not null)''');
    });
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    final result = await db.insert(tableName, alarmInfo.toMap());
    debugPrint(result.toString());
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> alarms = [];
    var db = await database;
    var result = await db.query(tableName);
    for (var element in result) {
      var alarmInfo = AlarmInfo.fromMap(element);
      alarms.add(alarmInfo);
    }
    debugPrint(alarms.first.title);

    return alarms;
  }

  delete(int? id) async {
    var db = await database;
    final result =
        await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
    debugPrint(result.toString());
  }

  update(int id, bool value) async {
    var db = await database;
    final String valueTra = value == true ? '1' : '0';
    int count = await db.rawUpdate(
        'UPDATE $tableName SET $columnIsPending= ? WHERE $columnId = ?',
        [valueTra, id]);
    debugPrint(count.toString());
  }
}
