class WorkoutPlan {
  final String id;
  final String title;
  final String workoutType; // running, strength, yoga, cycling, swimming, walking, custom
  final String? customTypeLabel;
  final int durationMinutes;
  final String frequency; // daily, weekdays, weekly, custom
  final String? customFrequencyDays; // JSON array like ["mon","wed","fri"]
  final String? timeOfDay; // morning, lunch, afternoon, evening, or custom HH:MM
  final bool reminderEnabled;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.workoutType,
    this.customTypeLabel,
    required this.durationMinutes,
    required this.frequency,
    this.customFrequencyDays,
    this.timeOfDay,
    this.reminderEnabled = false,
    this.notes,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'workout_type': workoutType,
      'custom_type_label': customTypeLabel,
      'duration_minutes': durationMinutes,
      'frequency': frequency,
      'custom_frequency_days': customFrequencyDays,
      'time_of_day': timeOfDay,
      'reminder_enabled': reminderEnabled ? 1 : 0,
      'notes': notes,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'],
      title: map['title'],
      workoutType: map['workout_type'],
      customTypeLabel: map['custom_type_label'],
      durationMinutes: map['duration_minutes'],
      frequency: map['frequency'],
      customFrequencyDays: map['custom_frequency_days'],
      timeOfDay: map['time_of_day'],
      reminderEnabled: map['reminder_enabled'] == 1,
      notes: map['notes'],
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  WorkoutPlan copyWith({
    String? id,
    String? title,
    String? workoutType,
    String? customTypeLabel,
    int? durationMinutes,
    String? frequency,
    String? customFrequencyDays,
    String? timeOfDay,
    bool? reminderEnabled,
    String? notes,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      workoutType: workoutType ?? this.workoutType,
      customTypeLabel: customTypeLabel ?? this.customTypeLabel,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      frequency: frequency ?? this.frequency,
      customFrequencyDays: customFrequencyDays ?? this.customFrequencyDays,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
