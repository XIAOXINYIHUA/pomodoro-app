import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../../models/daily_stat.dart';

class StatDao {
  Future<void> insertOrUpdate(DailyStat stat) async {
    final db = await AppDatabase.database;
    await db.insert('daily_stats', stat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<DailyStat?> getByDate(String date) async {
    final db = await AppDatabase.database;
    final maps = await db.query('daily_stats', where: 'date = ?', whereArgs: [date]);
    if (maps.isEmpty) return null;
    return DailyStat.fromMap(maps.first);
  }

  Future<List<DailyStat>> getByDateRange(String startDate, String endDate) async {
    final db = await AppDatabase.database;
    final maps = await db.query(
      'daily_stats',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date ASC',
    );
    return maps.map((m) => DailyStat.fromMap(m)).toList();
  }

  Future<List<DailyStat>> getUnsynced() async {
    final db = await AppDatabase.database;
    final maps = await db.query('daily_stats', where: 'is_synced = 0');
    return maps.map((m) => DailyStat.fromMap(m)).toList();
  }
}
