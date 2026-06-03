import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local/dao/workout_log_dao.dart';
import '../data/models/workout_log.dart';

class WorkoutLogProvider extends ChangeNotifier {
  final WorkoutLogDao _dao = WorkoutLogDao();
  List<WorkoutLog> _todayLogs = [];

  List<WorkoutLog> get todayLogs => _todayLogs;

  Future<void> loadTodayLogs() async {
    _todayLogs = await _dao.getByDate(DateTime.now());
    notifyListeners();
  }

  Future<WorkoutLog> addLog({
    String? planId,
    required String workoutType,
    required int durationMinutes,
    double caloriesBurned = 0,
    String? notes,
  }) async {
    final log = WorkoutLog(
      id: const Uuid().v4(),
      planId: planId,
      workoutType: workoutType,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      notes: notes,
      completedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await _dao.insert(log);
    _todayLogs.insert(0, log);
    notifyListeners();
    return log;
  }

  Future<void> deleteLog(String id) async {
    await _dao.delete(id);
    _todayLogs.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  Future<int> getCompletedCountByDate(DateTime date) async {
    return await _dao.getCompletedCountByDate(date);
  }
}
