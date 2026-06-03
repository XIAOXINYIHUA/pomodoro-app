import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class HealthProvider extends ChangeNotifier {
  final Health _health = Health();

  int _steps = 0;
  double _calories = 0;
  int _workoutMinutes = 0;
  double? _heartRate;
  double? _sleepHours;

  bool _isAuthorized = false;
  bool _isLoading = false;

  int get steps => _steps;
  double get calories => _calories;
  int get workoutMinutes => _workoutMinutes;
  double? get heartRate => _heartRate;
  double? get sleepHours => _sleepHours;
  bool get isAuthorized => _isAuthorized;
  bool get isLoading => _isLoading;

  Future<bool> requestAuthorization() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.EXERCISE_TIME,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_IN_BED,
    ];

    // 请求权限
    _isAuthorized = await _health.requestAuthorization(types);
    notifyListeners();
    return _isAuthorized;
  }

  Future<void> fetchTodayData() async {
    if (!_isAuthorized) {
      final authorized = await requestAuthorization();
      if (!authorized) return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      // 获取步数
      _steps = await _health.getTotalStepsInInterval(startOfDay, now) ?? 0;

      // 获取卡路里
      final caloriesData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startOfDay,
        endTime: now,
      );
      _calories = caloriesData.fold(
        0.0,
        (sum, point) => sum + (point.value as NumericHealthValue).numericValue.toDouble(),
      );

      // 获取运动时长
      final exerciseData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.EXERCISE_TIME],
        startTime: startOfDay,
        endTime: now,
      );
      _workoutMinutes = exerciseData.fold(
        0,
        (sum, point) => sum + (point.value as NumericHealthValue).numericValue.toInt(),
      );

      // 获取心率
      final heartRateData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: startOfDay,
        endTime: now,
      );
      if (heartRateData.isNotEmpty) {
        _heartRate = (heartRateData.last.value as NumericHealthValue).numericValue.toDouble();
      }

      // 获取睡眠
      final sleepData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_IN_BED],
        startTime: startOfDay.subtract(const Duration(days: 1)),
        endTime: now,
      );
      if (sleepData.isNotEmpty) {
        final totalSleep = sleepData.fold(
          0.0,
          (sum, point) => sum + (point.value as NumericHealthValue).numericValue.toDouble(),
        );
        _sleepHours = totalSleep / 60;
      }
    } catch (e) {
      debugPrint('Error fetching health data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
