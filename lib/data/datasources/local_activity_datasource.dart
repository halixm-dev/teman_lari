import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/activity_model.dart';

class LocalActivityDataSource {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'strava_activities.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY,
            data TEXT NOT NULL,
            synced_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE hr_streams (
            activity_id INTEGER PRIMARY KEY,
            data TEXT NOT NULL,
            synced_at INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS hr_streams (
              activity_id INTEGER PRIMARY KEY,
              data TEXT NOT NULL,
              synced_at INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> saveActivities(List<ActivityModel> activities) async {
    final db = await database;
    final batch = db.batch();
    for (final activity in activities) {
      batch.insert('activities', {
        'id': activity.id,
        'data': jsonEncode(activity.toJson()),
        'synced_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<ActivityModel>?> getCachedActivities() async {
    final db = await database;
    final rows = await db.query('activities', orderBy: 'id DESC');
    if (rows.isEmpty) return null;

    final oldest = rows.last['synced_at'] as int;
    final age = DateTime.now().millisecondsSinceEpoch - oldest;
    if (age > 3600 * 1000) return null;

    return rows
        .map((r) => ActivityModel.fromJson(jsonDecode(r['data'] as String)))
        .toList();
  }

  Future<void> saveHeartRateStream(int activityId, List<double> data) async {
    final db = await database;
    await db.insert('hr_streams', {
      'activity_id': activityId,
      'data': jsonEncode(data),
      'synced_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<int, List<double>>> getCachedHeartRateStreams() async {
    final db = await database;
    final rows = await db.query('hr_streams');
    if (rows.isEmpty) return {};

    final result = <int, List<double>>{};
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final row in rows) {
      final age = now - (row['synced_at'] as int);
      if (age > 3600 * 1000) continue;

      final id = row['activity_id'] as int;
      final raw = row['data'] as String;
      result[id] = (jsonDecode(raw) as List<dynamic>).cast<double>();
    }
    return result;
  }

  Future<void> clearCache() async {
    final db = await database;
    await db.delete('activities');
    await db.delete('hr_streams');
  }
}
