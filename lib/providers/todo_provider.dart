import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/local/dao/todo_dao.dart';
import '../data/models/todo_item.dart';

class TodoProvider extends ChangeNotifier {
  final TodoDao _dao = TodoDao();
  List<TodoItem> _todos = [];

  List<TodoItem> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await _dao.getAll();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final maxOrder = await _dao.getMaxSortOrder();
    final todo = TodoItem(
      id: const Uuid().v4(),
      title: title,
      sortOrder: maxOrder + 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dao.insert(todo);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> updateTodo(TodoItem todo) async {
    final updated = todo.copyWith(updatedAt: DateTime.now());
    await _dao.update(updated);
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    await _dao.delete(id);
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> toggleDone(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final todo = _todos[index];
    final updated = todo.copyWith(
      isDone: !todo.isDone,
      updatedAt: DateTime.now(),
    );
    await _dao.update(updated);
    _todos[index] = updated;
    notifyListeners();
  }
}
