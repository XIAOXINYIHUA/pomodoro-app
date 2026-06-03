import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/workout_log.dart';

class WorkoutLogDao {
  Future<void> insert(WorkoutLog log) async {
    final db = await AppDatabase.database;
    await db.insert('workout_logs', log.toMap());
  }

  Future<void> update(WorkoutLog log) async {
    final db = await AppDatabase.database;
    await db.update('workout_logs', log.toMap(), where: 'id = ?', whereArgs: [log.id]);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('workout_logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<WorkoutLog>> getByDate(DateTime date) async {
    final db = await AppDatabase.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final maps = await db.query(
      'workout_logs',
      where: 'completed_at LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: 'completed_at DESC',
    );
    return maps.map((m) => WorkoutLog.fromMap(m)).toList();
  }

  Future<List<WorkoutLog>> getByDateRange(DateTime start, DateTime end) async {
    final db = await AppDatabase.database;
    final maps = await db.query(
      'workout_logs',
      where: 'completed_at BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'completed_at DESC',
    );
    return maps.map((m) => WorkoutLog.fromMap(m)).toList();
  }

  Future<List<WorkoutLog>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('workout_logs', where: 'is_synced = 0');
    return maps.map((m) => WorkoutLog.fromMap(m)).toList();
  }

  Future<int> getCompletedCountByDate(DateTime date) async {
    final db = await AppDatabase.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_logs WHERE completed_at LIKE ?',
      ['$dateStr%'],
    );
    return result.first['count'] as int;
  }
}
