import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pomodoro_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // 番茄钟记录表
    await db.execute('''
      CREATE TABLE pomodoro_sessions (
        id TEXT PRIMARY KEY,
        task_id TEXT,
        work_duration INTEGER NOT NULL DEFAULT 1500,
        break_duration INTEGER NOT NULL DEFAULT 300,
        status TEXT NOT NULL DEFAULT 'completed',
        started_at TEXT NOT NULL,
        ended_at TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 任务表
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL DEFAULT 'todo',
        pomodoro_count INTEGER NOT NULL DEFAULT 0,
        estimated_pomodoros INTEGER,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 每日统计缓存表
    await db.execute('''
      CREATE TABLE daily_stats (
        date TEXT PRIMARY KEY,
        total_pomodoros INTEGER NOT NULL DEFAULT 0,
        total_focus_seconds INTEGER NOT NULL DEFAULT 0,
        completed_tasks INTEGER NOT NULL DEFAULT 0,
        steps INTEGER NOT NULL DEFAULT 0,
        calories REAL NOT NULL DEFAULT 0,
        workout_minutes INTEGER NOT NULL DEFAULT 0,
        sleep_hours REAL,
        planned_workouts INTEGER NOT NULL DEFAULT 0,
        completed_workouts INTEGER NOT NULL DEFAULT 0,
        is_synced INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');

    // 运动计划表
    await db.execute('''
      CREATE TABLE workout_plans (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        workout_type TEXT NOT NULL,
        custom_type_label TEXT,
        duration_minutes INTEGER NOT NULL,
        frequency TEXT NOT NULL DEFAULT 'daily',
        custom_frequency_days TEXT,
        time_of_day TEXT,
        reminder_enabled INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 运动完成记录表
    await db.execute('''
      CREATE TABLE workout_logs (
        id TEXT PRIMARY KEY,
        plan_id TEXT,
        workout_type TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        calories_burned REAL NOT NULL DEFAULT 0,
        notes TEXT,
        completed_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }
}
