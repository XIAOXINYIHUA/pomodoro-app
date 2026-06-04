import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../data/local/dao/pomodoro_dao.dart';
import '../data/models/pomodoro_session.dart';
import '../data/models/focus_plan.dart';

class TimerProvider extends ChangeNotifier {
  final PomodoroDao _dao = PomodoroDao();

  TimerState _state = TimerState.idle;
  int _workDuration = AppConstants.defaultWorkDuration * 60;
  int _breakDuration = AppConstants.defaultBreakDuration * 60;
  int _longBreakDuration = AppConstants.defaultLongBreakDuration * 60;
  int _longBreakInterval = AppConstants.defaultLongBreakInterval;

  int _remainingSeconds = 0;
  int _completedPomodoros = 0;
  String? _currentSessionId;
  DateTime? _sessionStartTime;
  String? _selectedTaskId;

  Timer? _timer;

  TimerState get state => _state;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _state == TimerState.breakTime ? _breakDuration : _workDuration;
  double get progress => totalSeconds > 0 ? 1 - (_remainingSeconds / totalSeconds) : 0;
  int get completedPomodoros => _completedPomodoros;
  String? get selectedTaskId => _selectedTaskId;

  String get timeDisplay {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get stateLabel {
    switch (_state) {
      case TimerState.idle:
        return '空闲';
      case TimerState.running:
        return '专注中';
      case TimerState.paused:
        return '已暂停';
      case TimerState.breakTime:
        return '休息中';
    }
  }

  void setWorkDuration(int minutes) {
    _workDuration = minutes * 60;
    if (_state == TimerState.idle) {
      _remainingSeconds = _workDuration;
    }
    notifyListeners();
  }

  void setBreakDuration(int minutes) {
    _breakDuration = minutes * 60;
    notifyListeners();
  }

  void setLongBreakDuration(int minutes) {
    _longBreakDuration = minutes * 60;
    notifyListeners();
  }

  /// 从专注计划加载配置（不自动开始）
  void loadPlanConfig(FocusPlan plan) {
    _workDuration = plan.workDuration * 60;
    _breakDuration = plan.breakDuration * 60;
    _longBreakDuration = plan.longBreakDuration * 60;
    _longBreakInterval = plan.longBreakInterval;
    if (_state == TimerState.idle) {
      _remainingSeconds = _workDuration;
    }
    notifyListeners();
  }

  void selectTask(String? taskId) {
    _selectedTaskId = taskId;
    notifyListeners();
  }

  void start() {
    if (_state == TimerState.idle) {
      _remainingSeconds = _workDuration;
      _currentSessionId = const Uuid().v4();
      _sessionStartTime = DateTime.now();
      _state = TimerState.running;
    } else if (_state == TimerState.paused) {
      _state = TimerState.running;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _state = TimerState.paused;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _state = TimerState.idle;
    _remainingSeconds = _workDuration;
    _currentSessionId = null;
    _sessionStartTime = null;
    notifyListeners();
  }

  void skip() {
    _timer?.cancel();
    if (_state == TimerState.running) {
      _saveSession(PomodoroStatus.skipped);
      _startBreak();
    } else if (_state == TimerState.breakTime) {
      _endBreak();
    }
  }

  void _onTick(Timer timer) {
    if (_remainingSeconds > 0) {
      _remainingSeconds--;
      notifyListeners();
    } else {
      timer.cancel();
      if (_state == TimerState.running) {
        _saveSession(PomodoroStatus.completed);
        _completedPomodoros++;
        _startBreak();
      } else if (_state == TimerState.breakTime) {
        _endBreak();
      }
    }
  }

  void _startBreak() {
    final isLongBreak = _completedPomodoros % _longBreakInterval == 0;
    _breakDuration = isLongBreak ? _longBreakDuration : AppConstants.defaultBreakDuration * 60;
    _remainingSeconds = _breakDuration;
    _state = TimerState.breakTime;
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    notifyListeners();
  }

  void _endBreak() {
    _state = TimerState.idle;
    _remainingSeconds = _workDuration;
    notifyListeners();
  }

  Future<void> _saveSession(PomodoroStatus status) async {
    if (_currentSessionId == null) return;

    final session = PomodoroSession(
      id: _currentSessionId!,
      taskId: _selectedTaskId,
      workDuration: _workDuration,
      breakDuration: _breakDuration,
      status: status.name,
      startedAt: _sessionStartTime!,
      endedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dao.insert(session);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
