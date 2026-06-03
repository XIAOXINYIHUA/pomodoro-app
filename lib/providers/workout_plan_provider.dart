import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local/dao/workout_plan_dao.dart';
import '../data/models/workout_plan.dart';

class WorkoutPlanProvider extends ChangeNotifier {
  final WorkoutPlanDao _dao = WorkoutPlanDao();
  List<WorkoutPlan> _plans = [];

  List<WorkoutPlan> get plans => _plans;

  Future<void> loadPlans() async {
    _plans = await _dao.getAll();
    notifyListeners();
  }

  Future<WorkoutPlan> addPlan({
    required String title,
    required String workoutType,
    String? customTypeLabel,
    required int durationMinutes,
    required String frequency,
    String? customFrequencyDays,
    String? timeOfDay,
    bool reminderEnabled = false,
    String? notes,
  }) async {
    final plan = WorkoutPlan(
      id: const Uuid().v4(),
      title: title,
      workoutType: workoutType,
      customTypeLabel: customTypeLabel,
      durationMinutes: durationMinutes,
      frequency: frequency,
      customFrequencyDays: customFrequencyDays,
      timeOfDay: timeOfDay,
      reminderEnabled: reminderEnabled,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dao.insert(plan);
    _plans.insert(0, plan);
    notifyListeners();
    return plan;
  }

  Future<void> updatePlan(WorkoutPlan plan) async {
    final updated = plan.copyWith(updatedAt: DateTime.now());
    await _dao.update(updated);
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _plans[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deletePlan(String id) async {
    await _dao.delete(id);
    _plans.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
