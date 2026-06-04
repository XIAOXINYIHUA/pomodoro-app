class FocusPlan {
  final String id;
  final String title;
  final int workDuration;       // 专注时长（分钟）
  final int breakDuration;      // 休息时长（分钟）
  final int longBreakDuration;  // 长休息时长（分钟）
  final int longBreakInterval;  // 长休息间隔（几个番茄后）
  final int? targetPomodoros;   // 目标番茄数
  final String frequency;       // daily, weekdays, weekly, custom
  final bool reminderEnabled;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  FocusPlan({
    required this.id,
    required this.title,
    this.workDuration = 25,
    this.breakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakInterval = 4,
    this.targetPomodoros,
    this.frequency = 'daily',
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
      'work_duration': workDuration,
      'break_duration': breakDuration,
      'long_break_duration': longBreakDuration,
      'long_break_interval': longBreakInterval,
      'target_pomodoros': targetPomodoros,
      'frequency': frequency,
      'reminder_enabled': reminderEnabled ? 1 : 0,
      'notes': notes,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory FocusPlan.fromMap(Map<String, dynamic> map) {
    return FocusPlan(
      id: map['id'],
      title: map['title'],
      workDuration: map['work_duration'] ?? 25,
      breakDuration: map['break_duration'] ?? 5,
      longBreakDuration: map['long_break_duration'] ?? 15,
      longBreakInterval: map['long_break_interval'] ?? 4,
      targetPomodoros: map['target_pomodoros'],
      frequency: map['frequency'] ?? 'daily',
      reminderEnabled: map['reminder_enabled'] == 1,
      notes: map['notes'],
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  FocusPlan copyWith({
    String? id,
    String? title,
    int? workDuration,
    int? breakDuration,
    int? longBreakDuration,
    int? longBreakInterval,
    int? targetPomodoros,
    String? frequency,
    bool? reminderEnabled,
    String? notes,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FocusPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      targetPomodoros: targetPomodoros ?? this.targetPomodoros,
      frequency: frequency ?? this.frequency,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
