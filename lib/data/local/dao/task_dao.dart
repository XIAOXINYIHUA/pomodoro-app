import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/task.dart';

class TaskDao {
  Future<void> insert(Task task) async {
    final db = await AppDatabase.database;
    await db.insert('tasks', task.toMap());
  }

  Future<void> update(Task task) async {
    final db = await AppDatabase.database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<Task?> getById(String id) async {
    final db = await AppDatabase.database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Task.fromMap(maps.first);
  }

  Future<List<Task>> getAll() async {
    final db = await AppDatabase.database;
    final maps = await db.query('tasks', orderBy: 'created_at DESC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getByStatus(String status) async {
    final db = await AppDatabase.database;
    final maps = await db.query('tasks', where: 'status = ?', whereArgs: [status], orderBy: 'created_at DESC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('tasks', where: 'is_synced = 0');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> getCompletedCountByDate(DateTime date) async {
    final db = await AppDatabase.database;
    final dateStr = date.toIso8601String().substring(0, 10);
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM tasks WHERE status = 'done' AND updated_at LIKE ?",
      ['$dateStr%'],
    );
    return result.first['count'] as int;
  }
}
