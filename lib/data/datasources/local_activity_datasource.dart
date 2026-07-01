import 'dart:convert';

import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/activity_model.dart';

class LocalActivityDataSource {
  static const _activitiesBoxName = 'activities';
  static const _hrStreamsBoxName = 'hr_streams';

  Box? _activitiesBox;
  Box? _hrStreamsBox;

  Future<Box> get activitiesBox async {
    final box = _activitiesBox ?? await Hive.openBox(_activitiesBoxName);
    _activitiesBox = box;
    return box;
  }

  Future<Box> get hrStreamsBox async {
    final box = _hrStreamsBox ?? await Hive.openBox(_hrStreamsBoxName);
    _hrStreamsBox = box;
    return box;
  }

  Future<void> saveActivities(List<ActivityModel> activities) async {
    try {
      final box = await activitiesBox;
      final Map<int, Map<String, dynamic>> entries = {};
      for (final activity in activities) {
        entries[activity.id] = {
          'id': activity.id,
          'data': jsonEncode(activity.toJson()),
          'synced_at': DateTime.now().millisecondsSinceEpoch,
        };
      }
      await box.putAll(entries);
    } catch (e, stackTrace) {
      log('Error saving activities', name: 'LocalActivityDataSource', error: e, stackTrace: stackTrace);
    }
  }

  Future<List<ActivityModel>?> getCachedActivities() async {
    try {
      final box = await activitiesBox;
      if (box.isEmpty) return null;

      final values = box.values.cast<Map>();
      final sortedList = values.toList()
        ..sort((a, b) {
          final idA = a['id'] as int;
          final idB = b['id'] as int;
          return idB.compareTo(idA);
        });

      final oldest = sortedList.last['synced_at'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - oldest;
      if (age > 3600 * 1000) return null;

      return sortedList
          .map((r) => ActivityModel.fromJson(jsonDecode(r['data'] as String)))
          .toList();
    } catch (e, stackTrace) {
      log('Error getting cached activities', name: 'LocalActivityDataSource', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> saveHeartRateStream(int activityId, List<double> data) async {
    try {
      final box = await hrStreamsBox;
      await box.put(activityId, {
        'activity_id': activityId,
        'data': jsonEncode(data),
        'synced_at': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, stackTrace) {
      log('Error saving heart rate stream', name: 'LocalActivityDataSource', error: e, stackTrace: stackTrace);
    }
  }

  Future<Map<int, List<double>>> getCachedHeartRateStreams() async {
    try {
      final box = await hrStreamsBox;
      if (box.isEmpty) return {};

      final result = <int, List<double>>{};
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final value in box.values) {
        final row = value as Map;
        final age = now - (row['synced_at'] as int);
        if (age > 3600 * 1000) continue;

        final id = row['activity_id'] as int;
        final raw = row['data'] as String;
        result[id] = (jsonDecode(raw) as List<dynamic>).cast<double>();
      }
      return result;
    } catch (e, stackTrace) {
      log('Error getting cached heart rate streams', name: 'LocalActivityDataSource', error: e, stackTrace: stackTrace);
      return {};
    }
  }

  Future<void> clearCache() async {
    try {
      final boxAct = await activitiesBox;
      final boxHr = await hrStreamsBox;
      await boxAct.clear();
      await boxHr.clear();
    } catch (e, stackTrace) {
      log('Error clearing cache', name: 'LocalActivityDataSource', error: e, stackTrace: stackTrace);
    }
  }
}
