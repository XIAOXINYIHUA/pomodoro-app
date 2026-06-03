class PomodoroSession {
  final String id;
  final String? taskId;
  final int workDuration;
  final int breakDuration;
  final String status; // completed, interrupted, skipped
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  PomodoroSession({
    required this.id,
    this.taskId,
    required this.workDuration,
    required this.breakDuration,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'work_duration': workDuration,
      'break_duration': breakDuration,
      'status': status,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PomodoroSession.fromMap(Map<String, dynamic> map) {
    return PomodoroSession(
      id: map['id'],
      taskId: map['task_id'],
      workDuration: map['work_duration'],
      breakDuration: map['break_duration'],
      status: map['status'],
      startedAt: DateTime.parse(map['started_at']),
      endedAt: map['ended_at'] != null ? DateTime.parse(map['ended_at']) : null,
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  PomodoroSession copyWith({
    String? id,
    String? taskId,
    int? workDuration,
    int? breakDuration,
    String? status,
    DateTime? startedAt,
    DateTime? endedAt,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
