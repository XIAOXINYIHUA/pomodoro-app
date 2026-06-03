import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local/dao/task_dao.dart';
import '../data/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final TaskDao _dao = TaskDao();
  List<Task> _tasks = [];
  String _filter = 'all'; // all, todo, in_progress, done

  List<Task> get tasks {
    switch (_filter) {
      case 'todo':
        return _tasks.where((t) => t.status == 'todo').toList();
      case 'in_progress':
        return _tasks.where((t) => t.status == 'in_progress').toList();
      case 'done':
        return _tasks.where((t) => t.status == 'done').toList();
      default:
        return _tasks;
    }
  }

  List<Task> get allTasks => _tasks;
  String get filter => _filter;

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await _dao.getAll();
    notifyListeners();
  }

  Future<Task> addTask(String title, {String? description, int? estimatedPomodoros}) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: 'todo',
      estimatedPomodoros: estimatedPomodoros,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dao.insert(task);
    _tasks.insert(0, task);
    notifyListeners();
    return task;
  }

  Future<void> updateTask(Task task) async {
    final updated = task.copyWith(updatedAt: DateTime.now());
    await _dao.update(updated);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    await _dao.delete(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> incrementPomodoro(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updated = task.copyWith(
      pomodoroCount: task.pomodoroCount + 1,
      status: 'in_progress',
      updatedAt: DateTime.now(),
    );
    await _dao.update(updated);
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> completeTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updated = task.copyWith(
      status: 'done',
      updatedAt: DateTime.now(),
    );
    await _dao.update(updated);
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }
}
