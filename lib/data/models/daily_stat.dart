class DailyStat {
  final String date; // YYYY-MM-DD
  final int totalPomodoros;
  final int totalFocusSeconds;
  final int completedTasks;
  final int steps;
  final double calories;
  final int workoutMinutes;
  final double? sleepHours;
  final int plannedWorkouts;
  final int completedWorkouts;
  final bool isSynced;
  final DateTime updatedAt;

  DailyStat({
    required this.date,
    this.totalPomodoros = 0,
    this.totalFocusSeconds = 0,
    this.completedTasks = 0,
    this.steps = 0,
    this.calories = 0,
    this.workoutMinutes = 0,
    this.sleepHours,
    this.plannedWorkouts = 0,
    this.completedWorkouts = 0,
    this.isSynced = false,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'total_pomodoros': totalPomodoros,
      'total_focus_seconds': totalFocusSeconds,
      'completed_tasks': completedTasks,
      'steps': steps,
      'calories': calories,
      'workout_minutes': workoutMinutes,
      'sleep_hours': sleepHours,
      'planned_workouts': plannedWorkouts,
      'completed_workouts': completedWorkouts,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DailyStat.fromMap(Map<String, dynamic> map) {
    return DailyStat(
      date: map['date'],
      totalPomodoros: map['total_pomodoros'] ?? 0,
      totalFocusSeconds: map['total_focus_seconds'] ?? 0,
      completedTasks: map['completed_tasks'] ?? 0,
      steps: map['steps'] ?? 0,
      calories: (map['calories'] ?? 0).toDouble(),
      workoutMinutes: map['workout_minutes'] ?? 0,
      sleepHours: map['sleep_hours']?.toDouble(),
      plannedWorkouts: map['planned_workouts'] ?? 0,
      completedWorkouts: map['completed_workouts'] ?? 0,
      isSynced: map['is_synced'] == 1,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  DailyStat copyWith({
    String? date,
    int? totalPomodoros,
    int? totalFocusSeconds,
    int? completedTasks,
    int? steps,
    double? calories,
    int? workoutMinutes,
    double? sleepHours,
    int? plannedWorkouts,
    int? completedWorkouts,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return DailyStat(
      date: date ?? this.date,
      totalPomodoros: totalPomodoros ?? this.totalPomodoros,
      totalFocusSeconds: totalFocusSeconds ?? this.totalFocusSeconds,
      completedTasks: completedTasks ?? this.completedTasks,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      sleepHours: sleepHours ?? this.sleepHours,
      plannedWorkouts: plannedWorkouts ?? this.plannedWorkouts,
      completedWorkouts: completedWorkouts ?? this.completedWorkouts,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
