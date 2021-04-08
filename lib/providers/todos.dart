import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class Todos with ChangeNotifier {
  List<Todo> _todos = [];
  final String authToken;
  final String userId;
  Todos(
    this.authToken,
    this.userId,
    this._todos,
  );

  List<Todo> get allTodos => _todos;

  void _setIsDone(Task task, bool newValue) {
    task.isDone = newValue;
    notifyListeners();
  }

  Future<List<Todo>> fetchAndSetTodos() async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userTodos/$userId.json?auth=$authToken';
    try {
      List<Todo> loadedTodos = [];
      final response = await http.get(url);
      final fetchedData = jsonDecode(response.body);

      fetchedData != null
          ? fetchedData.forEach((todoId, todoDataMap) {
              List<Task> tasks = [];
              Map<String, dynamic>.from(todoDataMap)['tasks'] != null
                  ? Map<String, dynamic>.from(todoDataMap)['tasks']
                      .forEach((taskId, taskDataMap) {
                      tasks.add(Task(
                          id: taskId,
                          name: Map<String, dynamic>.from(taskDataMap)['name'],
                          isDone: Map<String, dynamic>.from(
                              taskDataMap)['isDone']));
                    })
                  : tasks = <Task>[];
              loadedTodos.add(Todo(
                  id: todoId,
                  name: Map<String, dynamic>.from(todoDataMap)['name'],
                  tasks: tasks));
            })
          : loadedTodos = [];

      _todos = loadedTodos;
      notifyListeners();
    } catch (error) {
      print(error);
    }
    return _todos;
  }

  Future<void> addTodo(Todo newTodo) async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userTodos/$userId.json?auth=$authToken';
    try {
      final response =
          await http.post(url, body: jsonEncode({'name': newTodo.name}));

      final newTodoId = jsonDecode(response.body)['name'];
      final addedTodo = Todo(id: newTodoId, name: newTodo.name, tasks: []);
      if (_todos == null) {
        _todos = [];
        _todos.add(addedTodo);
        notifyListeners();
      } else {
        _todos.add(addedTodo);
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> editTodo(String todoId, String newTodoName) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == todoId);
    if (todoIndex >= 0) {
      final url =
          'https://what-to-do-f434a.firebaseio.com/userTodos/$userId/$todoId.json?auth=$authToken';
      try {
        await http.patch(url, body: jsonEncode({'name': newTodoName}));
        _todos[todoIndex].name = newTodoName;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userTodos/$userId/$todoId.json?auth=$authToken';

    final existingTodoIndex = _todos.indexWhere((todo) => todo.id == todoId);
    var existingTodo = _todos[existingTodoIndex];
    _todos.removeAt(existingTodoIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _todos.insert(existingTodoIndex, existingTodo);
        notifyListeners();
      }
    } catch (error) {
      print(error);
      _todos.insert(existingTodoIndex, existingTodo);
      notifyListeners();
      throw error;
    }

    existingTodo = null;
  }

  Future<void> addTask(String todoId, String taskName) async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userTodos/$userId/$todoId/tasks.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: jsonEncode({'name': taskName, 'isDone': false}));
      final newTask = new Task(
          id: jsonDecode(response.body)['name'], name: taskName, isDone: false);
      _todos.firstWhere((todo) => todo.id == todoId).tasks.add(newTask);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> editask(String todoId, String taskId, String newTaskName) async {
    final todo = _todos.firstWhere((todo) => todo.id == todoId);
    final taskIndex = todo.tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex >= 0) {
      final url =
          'https://what-to-do-f434a.firebaseio.com/userTodos/$userId/$todoId/tasks/$taskId.json?auth=$authToken';
      try {
        await http.patch(url, body: jsonEncode({'name': newTaskName}));
        todo.tasks[taskIndex].name = newTaskName;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteTask(String todoId, String taskId) async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userTodos/$userId/$todoId/tasks/$taskId.json?auth=$authToken';

    final todo = _todos.firstWhere((todo) => todo.id == todoId);
    final taskIndex = todo.tasks.indexWhere((task) => task.id == taskId);
    var existingTask = todo.tasks[taskIndex];
    todo.tasks.removeAt(taskIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        todo.tasks.insert(taskIndex, existingTask);
        notifyListeners();
      }
    } catch (error) {
      print(error);
      todo.tasks.insert(taskIndex, existingTask);
      notifyListeners();
      throw error;
    }

    existingTask = null;
  }

  Future<void> toggleIsDoneStatus(String todoId, String taskId) async {
    final todo = _todos.firstWhere((todo) => todo.id == todoId);
    final taskIndex = todo.tasks.indexWhere((task) => task.id == taskId);
    var existingTask = todo.tasks[taskIndex];
    final oldStatus = existingTask.isDone;
    existingTask.isDone = !existingTask.isDone;
    todo.calculateProgress();
    notifyListeners();
    final url =
        'https://what-to-do-f434a.firebaseio.com/userTodos/$userId/$todoId/tasks/$taskId.json?auth=$authToken';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isDone': existingTask.isDone,
        }),
      );
      notifyListeners();
      if (response.statusCode >= 400) {
        _setIsDone(existingTask, oldStatus);
      }
    } catch (error) {
      _setIsDone(existingTask, oldStatus);
    }
  }
}
