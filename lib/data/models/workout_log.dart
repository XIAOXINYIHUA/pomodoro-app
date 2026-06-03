class WorkoutLog {
  final String id;
  final String? planId;
  final String workoutType;
  final int durationMinutes;
  final double caloriesBurned;
  final String? notes;
  final DateTime completedAt;
  final bool isSynced;
  final DateTime createdAt;

  WorkoutLog({
    required this.id,
    this.planId,
    required this.workoutType,
    required this.durationMinutes,
    this.caloriesBurned = 0,
    this.notes,
    required this.completedAt,
    this.isSynced = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plan_id': planId,
      'workout_type': workoutType,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'notes': notes,
      'completed_at': completedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'],
      planId: map['plan_id'],
      workoutType: map['workout_type'],
      durationMinutes: map['duration_minutes'],
      caloriesBurned: (map['calories_burned'] ?? 0).toDouble(),
      notes: map['notes'],
      completedAt: DateTime.parse(map['completed_at']),
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  WorkoutLog copyWith({
    String? id,
    String? planId,
    String? workoutType,
    int? durationMinutes,
    double? caloriesBurned,
    String? notes,
    DateTime? completedAt,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      workoutType: workoutType ?? this.workoutType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
