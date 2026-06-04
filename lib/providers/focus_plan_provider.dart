import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local/dao/focus_plan_dao.dart';
import '../data/models/focus_plan.dart';

class FocusPlanProvider extends ChangeNotifier {
  final FocusPlanDao _dao = FocusPlanDao();
  List<FocusPlan> _plans = [];

  List<FocusPlan> get plans => _plans;

  Future<void> loadPlans() async {
    _plans = await _dao.getAll();
    notifyListeners();
  }

  Future<FocusPlan> addPlan({
    required String title,
    int workDuration = 25,
    int breakDuration = 5,
    int longBreakDuration = 15,
    int longBreakInterval = 4,
    int? targetPomodoros,
    String frequency = 'daily',
    bool reminderEnabled = false,
    String? notes,
  }) async {
    final plan = FocusPlan(
      id: const Uuid().v4(),
      title: title,
      workDuration: workDuration,
      breakDuration: breakDuration,
      longBreakDuration: longBreakDuration,
      longBreakInterval: longBreakInterval,
      targetPomodoros: targetPomodoros,
      frequency: frequency,
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

  Future<void> updatePlan(FocusPlan plan) async {
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
