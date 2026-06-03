import 'package:flutter/foundation.dart';
import '../core/utils/date_utils.dart';
import '../data/local/dao/stat_dao.dart';
import '../data/local/dao/pomodoro_dao.dart';
import '../data/local/dao/task_dao.dart';
import '../data/models/daily_stat.dart';

class StatProvider extends ChangeNotifier {
  final StatDao _statDao = StatDao();
  final PomodoroDao _pomodoroDao = PomodoroDao();
  final TaskDao _taskDao = TaskDao();

  DailyStat? _todayStat;
  List<DailyStat> _weekStats = [];
  List<DailyStat> _monthStats = [];

  DailyStat? get todayStat => _todayStat;
  List<DailyStat> get weekStats => _weekStats;
  List<DailyStat> get monthStats => _monthStats;

  Future<void> loadTodayStats() async {
    final today = AppDateUtils.formatDate(DateTime.now());
    _todayStat = await _statDao.getByDate(today);

    if (_todayStat == null) {
      _todayStat = DailyStat(
        date: today,
        updatedAt: DateTime.now(),
      );
      await _statDao.insertOrUpdate(_todayStat!);
    }

    // 从番茄记录更新
    final pomodoroCount = await _pomodoroDao.getCountByDate(DateTime.now());
    final focusSeconds = await _pomodoroDao.getTotalFocusSecondsByDate(DateTime.now());
    final completedTasks = await _taskDao.getCompletedCountByDate(DateTime.now());

    _todayStat = _todayStat!.copyWith(
      totalPomodoros: pomodoroCount,
      totalFocusSeconds: focusSeconds,
      completedTasks: completedTasks,
      updatedAt: DateTime.now(),
    );

    await _statDao.insertOrUpdate(_todayStat!);
    notifyListeners();
  }

  Future<void> loadWeekStats() async {
    final now = DateTime.now();
    final startOfWeek = AppDateUtils.getStartOfWeek(now);
    final endOfWeek = AppDateUtils.getEndOfWeek(now);

    _weekStats = await _statDao.getByDateRange(
      AppDateUtils.formatDate(startOfWeek),
      AppDateUtils.formatDate(endOfWeek),
    );
    notifyListeners();
  }

  Future<void> loadMonthStats() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    _monthStats = await _statDao.getByDateRange(
      AppDateUtils.formatDate(startOfMonth),
      AppDateUtils.formatDate(endOfMonth),
    );
    notifyListeners();
  }

  Future<void> updateHealthData({int? steps, double? calories, int? workoutMinutes}) async {
    if (_todayStat == null) return;

    _todayStat = _todayStat!.copyWith(
      steps: steps ?? _todayStat!.steps,
      calories: calories ?? _todayStat!.calories,
      workoutMinutes: workoutMinutes ?? _todayStat!.workoutMinutes,
      updatedAt: DateTime.now(),
    );

    await _statDao.insertOrUpdate(_todayStat!);
    notifyListeners();
  }
}
