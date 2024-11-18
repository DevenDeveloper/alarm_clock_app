import 'package:clock_app/app/data/models/alarm_info.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'alarmDateTime';
final String columnPending = 'isPending';
final String columnColorIndex = 'gradientColorIndex';

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    _alarmHelper ??= AlarmHelper._createInstance();
    return _alarmHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer,
          $columnColorIndex integer)
        ''');
      },
    );
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    if (kDebugMode) {
      print('result : $result');
    }
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> alarms = [];

    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      var alarmInfo = AlarmInfo.fromMap(element);
      alarms.add(alarmInfo);
    }

    return alarms;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
