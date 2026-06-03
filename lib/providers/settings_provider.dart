import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  int _workDuration = AppConstants.defaultWorkDuration;
  int _breakDuration = AppConstants.defaultBreakDuration;
  int _longBreakDuration = AppConstants.defaultLongBreakDuration;
  int _longBreakInterval = AppConstants.defaultLongBreakInterval;

  int _stepGoal = AppConstants.defaultStepGoal;
  int _calorieGoal = AppConstants.defaultCalorieGoal;
  int _workoutMinutesGoal = AppConstants.defaultWorkoutMinutesGoal;

  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _themeMode = 'system'; // light, dark, system

  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;
  int get longBreakDuration => _longBreakDuration;
  int get longBreakInterval => _longBreakInterval;

  int get stepGoal => _stepGoal;
  int get calorieGoal => _calorieGoal;
  int get workoutMinutesGoal => _workoutMinutesGoal;

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get themeMode => _themeMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _workDuration = _prefs.getInt('work_duration') ?? AppConstants.defaultWorkDuration;
    _breakDuration = _prefs.getInt('break_duration') ?? AppConstants.defaultBreakDuration;
    _longBreakDuration = _prefs.getInt('long_break_duration') ?? AppConstants.defaultLongBreakDuration;
    _longBreakInterval = _prefs.getInt('long_break_interval') ?? AppConstants.defaultLongBreakInterval;

    _stepGoal = _prefs.getInt('step_goal') ?? AppConstants.defaultStepGoal;
    _calorieGoal = _prefs.getInt('calorie_goal') ?? AppConstants.defaultCalorieGoal;
    _workoutMinutesGoal = _prefs.getInt('workout_minutes_goal') ?? AppConstants.defaultWorkoutMinutesGoal;

    _darkMode = _prefs.getBool('dark_mode') ?? false;
    _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
    _themeMode = _prefs.getString('theme_mode') ?? 'system';

    notifyListeners();
  }

  Future<void> setWorkDuration(int value) async {
    _workDuration = value;
    await _prefs.setInt('work_duration', value);
    notifyListeners();
  }

  Future<void> setBreakDuration(int value) async {
    _breakDuration = value;
    await _prefs.setInt('break_duration', value);
    notifyListeners();
  }

  Future<void> setLongBreakDuration(int value) async {
    _longBreakDuration = value;
    await _prefs.setInt('long_break_duration', value);
    notifyListeners();
  }

  Future<void> setLongBreakInterval(int value) async {
    _longBreakInterval = value;
    await _prefs.setInt('long_break_interval', value);
    notifyListeners();
  }

  Future<void> setStepGoal(int value) async {
    _stepGoal = value;
    await _prefs.setInt('step_goal', value);
    notifyListeners();
  }

  Future<void> setCalorieGoal(int value) async {
    _calorieGoal = value;
    await _prefs.setInt('calorie_goal', value);
    notifyListeners();
  }

  Future<void> setWorkoutMinutesGoal(int value) async {
    _workoutMinutesGoal = value;
    await _prefs.setInt('workout_minutes_goal', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<void> setThemeMode(String value) async {
    _themeMode = value;
    await _prefs.setString('theme_mode', value);
    notifyListeners();
  }
}
