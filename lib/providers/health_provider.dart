import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../core/l10n/app_strings.dart';

/// 健康数据管理
///
/// 支持 Apple HealthKit（iOS）和 Google Health Connect（Android）。
///
/// ## 华为设备兼容
/// 华为设备无 Google Play Services，Health Connect 不可用。
/// 检测失败后自动降级为纯手动模式，后续版本将接入华为 Health Kit。
class HealthProvider extends ChangeNotifier {
  final Health _health = Health();

  int _steps = 0;
  double _calories = 0;
  int _workoutMinutes = 0;
  double? _heartRate;
  double? _sleepHours;
  double _distanceKm = 0;
  int _floorsClimbed = 0;
  double? _bloodOxygen;
  double? _weight;

  /// 数据来源列表（APP 名称）
  final List<String> _dataSources = [];

  bool _isAuthorized = false;
  bool _isLoading = false;
  String? _errorMessage;

  /// 健康服务是否可用（Huawei 无 GMS 时为 false）
  bool _healthServiceAvailable = true;

  int get steps => _steps;
  double get calories => _calories;
  int get workoutMinutes => _workoutMinutes;
  double? get heartRate => _heartRate;
  double? get sleepHours => _sleepHours;
  double get distanceKm => _distanceKm;
  int get floorsClimbed => _floorsClimbed;
  double? get bloodOxygen => _bloodOxygen;
  double? get weight => _weight;
  List<String> get dataSources => _dataSources;
  bool get isAuthorized => _isAuthorized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get healthServiceAvailable => _healthServiceAvailable;

  void setSteps(int steps) {
    _steps = steps;
    notifyListeners();
  }

  void setCalories(double calories) {
    _calories = calories;
    notifyListeners();
  }

  void setWorkoutMinutes(int minutes) {
    _workoutMinutes = minutes;
    notifyListeners();
  }

  Future<bool> requestAuthorization() async {
    // 如果已知服务不可用，直接返回 false
    if (!_healthServiceAvailable) {
      _errorMessage = AppStrings.healthServiceUnavailable;
      notifyListeners();
      return false;
    }

    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.EXERCISE_TIME,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.FLIGHTS_CLIMBED,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.WEIGHT,
    ];

    try {
      _isAuthorized = await _health.requestAuthorization(types);
      if (!_isAuthorized) {
        _errorMessage = AppStrings.healthAuthDenied;
      }
    } catch (e) {
      // Huawei 设备：Google Health Connect 不可用
      debugPrint('Health Connect authorization failed: $e');
      _healthServiceAvailable = false;
      _isAuthorized = false;
      _errorMessage = AppStrings.healthServiceUnavailable;
    }

    notifyListeners();
    return _isAuthorized;
  }

  Future<void> fetchTodayData() async {
    // 服务不可用时直接返回
    if (!_healthServiceAvailable) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (!_isAuthorized) {
      final authorized = await requestAuthorization();
      if (!authorized) return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      // 步数
      _steps = await _health.getTotalStepsInInterval(startOfDay, now) ?? 0;

      // 卡路里
      final caloriesData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startOfDay,
        endTime: now,
      );
      _calories = _sumNumeric(caloriesData);

      // 运动时长
      final exerciseData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.EXERCISE_TIME],
        startTime: startOfDay,
        endTime: now,
      );
      _workoutMinutes = _sumNumeric(exerciseData).toInt();

      // 心率
      final heartRateData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: startOfDay,
        endTime: now,
      );
      if (heartRateData.isNotEmpty) {
        _heartRate = (heartRateData.last.value as NumericHealthValue).numericValue.toDouble();
      }

      // 睡眠
      final sleepData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_IN_BED],
        startTime: startOfDay.subtract(const Duration(days: 1)),
        endTime: now,
      );
      if (sleepData.isNotEmpty) {
        final totalSleep = _sumNumeric(sleepData);
        _sleepHours = totalSleep / 60;
      }

      // 距离（米 → 公里）
      final distanceData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.DISTANCE_DELTA],
        startTime: startOfDay,
        endTime: now,
      );
      _distanceKm = _sumNumeric(distanceData) / 1000;

      // 楼层
      final floorData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.FLIGHTS_CLIMBED],
        startTime: startOfDay,
        endTime: now,
      );
      _floorsClimbed = _sumNumeric(floorData).toInt();

      // 血氧
      final oxygenData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.BLOOD_OXYGEN],
        startTime: startOfDay,
        endTime: now,
      );
      if (oxygenData.isNotEmpty) {
        _bloodOxygen = (oxygenData.last.value as NumericHealthValue).numericValue.toDouble();
      }

      // 体重
      final weightData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: startOfDay,
        endTime: now,
      );
      if (weightData.isNotEmpty) {
        _weight = (weightData.last.value as NumericHealthValue).numericValue.toDouble();
      }

      // 收集数据来源
      _dataSources.clear();
      final allData = [
        ...caloriesData,
        ...exerciseData,
        ...heartRateData,
        ...sleepData,
        ...distanceData,
        ...floorData,
        ...oxygenData,
        ...weightData,
      ];
      final sourceNames = <String>{};
      for (final point in allData) {
        if (point.sourceName.isNotEmpty) {
          sourceNames.add(point.sourceName);
        }
      }
      _dataSources.addAll(sourceNames);

      _errorMessage = null;
    } catch (e) {
      // 华为设备：Health Connect 抛出异常
      debugPrint('Error fetching health data: $e');
      _healthServiceAvailable = false;
      _isAuthorized = false;
      _errorMessage = AppStrings.healthServiceUnavailable;
    }

    _isLoading = false;
    notifyListeners();
  }

  double _sumNumeric(List<HealthDataPoint> data) {
    return data.fold(
      0.0,
      (sum, point) => sum + (point.value as NumericHealthValue).numericValue.toDouble(),
    );
  }
}
