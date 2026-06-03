import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/workout_plan.dart';

class WorkoutPlanDao {
  Future<void> insert(WorkoutPlan plan) async {
    final db = await AppDatabase.database;
    await db.insert('workout_plans', plan.toMap());
  }

  Future<void> update(WorkoutPlan plan) async {
    final db = await AppDatabase.database;
    await db.update('workout_plans', plan.toMap(), where: 'id = ?', whereArgs: [plan.id]);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('workout_plans', where: 'id = ?', whereArgs: [id]);
  }

  Future<WorkoutPlan?> getById(String id) async {
    final db = await AppDatabase.database;
    final maps = await db.query('workout_plans', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return WorkoutPlan.fromMap(maps.first);
  }

  Future<List<WorkoutPlan>> getAll() async {
    final db = await AppDatabase.database;
    final maps = await db.query('workout_plans', orderBy: 'created_at DESC');
    return maps.map((m) => WorkoutPlan.fromMap(m)).toList();
  }

  Future<List<WorkoutPlan>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('workout_plans', where: 'is_synced = 0');
    return maps.map((m) => WorkoutPlan.fromMap(m)).toList();
  }
}
