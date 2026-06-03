// 运动类型枚举
enum WorkoutType {
  running('跑步'),
  strength('力量训练'),
  yoga('瑜伽'),
  cycling('骑行'),
  swimming('游泳'),
  walking('散步'),
  custom('自定义');

  final String label;
  const WorkoutType(this.label);
}

// 频率枚举
enum WorkoutFrequency {
  daily('每天'),
  weekdays('工作日'),
  weekly('每周'),
  custom('自定义');

  final String label;
  const WorkoutFrequency(this.label);
}

// 时间段枚举
enum TimeOfDay {
  morning('早上'),
  lunch('中午'),
  afternoon('下午'),
  evening('晚上'),
  custom('自定义');

  final String label;
  const TimeOfDay(this.label);
}

// 番茄钟状态
enum TimerState {
  idle('空闲'),
  running('专注中'),
  paused('已暂停'),
  breakTime('休息中');

  final String label;
  const TimerState(this.label);
}

// 任务状态
enum TaskStatus {
  todo('待做'),
  inProgress('进行中'),
  done('已完成');

  final String label;
  const TaskStatus(this.label);
}

// 番茄钟记录状态
enum PomodoroStatus {
  completed('已完成'),
  interrupted('中断'),
  skipped('跳过');

  final String label;
  const PomodoroStatus(this.label);
}

class AppConstants {
  // 番茄钟默认值
  static const int defaultWorkDuration = 25; // 分钟
  static const int defaultBreakDuration = 5; // 分钟
  static const int defaultLongBreakDuration = 15; // 分钟
  static const int defaultLongBreakInterval = 4; // 每4个番茄后长休息

  // 运动目标默认值
  static const int defaultStepGoal = 10000;
  static const int defaultCalorieGoal = 500;
  static const int defaultWorkoutMinutesGoal = 30;

  // 数据库表名
  static const String tablePomodoroSessions = 'pomodoro_sessions';
  static const String tableTasks = 'tasks';
  static const String tableDailyStats = 'daily_stats';
  static const String tableWorkoutPlans = 'workout_plans';
  static const String tableWorkoutLogs = 'workout_logs';
}
