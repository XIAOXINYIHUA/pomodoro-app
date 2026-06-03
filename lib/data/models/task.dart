class Task {
  final String id;
  final String title;
  final String? description;
  final String status; // todo, in_progress, done
  final int pomodoroCount;
  final int? estimatedPomodoros;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.pomodoroCount = 0,
    this.estimatedPomodoros,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'pomodoro_count': pomodoroCount,
      'estimated_pomodoros': estimatedPomodoros,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      pomodoroCount: map['pomodoro_count'] ?? 0,
      estimatedPomodoros: map['estimated_pomodoros'],
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    int? pomodoroCount,
    int? estimatedPomodoros,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
