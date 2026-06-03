import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/pomodoro_session.dart';

class PomodoroDao {
  Future<void> insert(PomodoroSession session) async {
    final db = await AppDatabase.database;
    await db.insert('pomodoro_sessions', session.toMap());
  }

  Future<void> update(PomodoroSession session) async {
    final db = await AppDatabase.database;
    await db.update(
      'pomodoro_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('pomodoro_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<PomodoroSession?> getById(String id) async {
    final db = await AppDatabase.database;
    final maps = await db.query('pomodoro_sessions', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return PomodoroSession.fromMap(maps.first);
  }

  Future<List<PomodoroSession>> getByDate(DateTime date) async {
    final db = await AppDatabase.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final maps = await db.query(
      'pomodoro_sessions',
      where: 'started_at LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: 'started_at DESC',
    );
    return maps.map((m) => PomodoroSession.fromMap(m)).toList();
  }

  Future<List<PomodoroSession>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('pomodoro_sessions', where: 'is_synced = 0');
    return maps.map((m) => PomodoroSession.fromMap(m)).toList();
  }

  Future<int> getCountByDate(DateTime date) async {
    final db = await AppDatabase.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM pomodoro_sessions WHERE started_at LIKE ? AND status = ?',
      ['$dateStr%', 'completed'],
    );
    return result.first['count'] as int;
  }

  Future<int> getTotalFocusSecondsByDate(DateTime date) async {
    final db = await AppDatabase.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final result = await db.rawQuery(
      'SELECT SUM(work_duration) as total FROM pomodoro_sessions WHERE started_at LIKE ? AND status = ?',
      ['$dateStr%', 'completed'],
    );
    return (result.first['total'] as int?) ?? 0;
  }
}
