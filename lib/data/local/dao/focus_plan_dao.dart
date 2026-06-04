import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/focus_plan.dart';

class FocusPlanDao {
  Future<void> insert(FocusPlan plan) async {
    final db = await AppDatabase.database;
    await db.insert('focus_plans', plan.toMap());
  }

  Future<void> update(FocusPlan plan) async {
    final db = await AppDatabase.database;
    await db.update('focus_plans', plan.toMap(), where: 'id = ?', whereArgs: [plan.id]);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('focus_plans', where: 'id = ?', whereArgs: [id]);
  }

  Future<FocusPlan?> getById(String id) async {
    final db = await AppDatabase.database;
    final maps = await db.query('focus_plans', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return FocusPlan.fromMap(maps.first);
  }

  Future<List<FocusPlan>> getAll() async {
    final db = await AppDatabase.database;
    final maps = await db.query('focus_plans', orderBy: 'created_at DESC');
    return maps.map((m) => FocusPlan.fromMap(m)).toList();
  }

  Future<List<FocusPlan>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('focus_plans', where: 'is_synced = 0');
    return maps.map((m) => FocusPlan.fromMap(m)).toList();
  }
}
