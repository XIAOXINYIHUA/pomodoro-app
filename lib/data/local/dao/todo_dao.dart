import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/todo_item.dart';

class TodoDao {
  Future<void> insert(TodoItem todo) async {
    final db = await AppDatabase.database;
    await db.insert('todos', todo.toMap());
  }

  Future<void> update(TodoItem todo) async {
    final db = await AppDatabase.database;
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<TodoItem?> getById(String id) async {
    final db = await AppDatabase.database;
    final maps = await db.query('todos', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return TodoItem.fromMap(maps.first);
  }

  Future<List<TodoItem>> getAll() async {
    final db = await AppDatabase.database;
    final maps = await db.query('todos', orderBy: 'sort_order ASC, created_at DESC');
    return maps.map((m) => TodoItem.fromMap(m)).toList();
  }

  Future<List<TodoItem>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('todos', where: 'is_synced = 0');
    return maps.map((m) => TodoItem.fromMap(m)).toList();
  }

  Future<int> getMaxSortOrder() async {
    final db = await AppDatabase.database;
    final result = await db.rawQuery('SELECT MAX(sort_order) as max_order FROM todos');
    return (result.first['max_order'] as int?) ?? 0;
  }
}
