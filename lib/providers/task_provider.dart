import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.progressPercentage == 100).toList();

  List<TaskModel> get ongoingTasks =>
      _tasks.where((task) => task.progressPercentage < 100).toList();

  Future<void> loadTasks(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _taskService.getTasks(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void streamTasks(String userId) {
    _taskService.streamTasks(userId).listen(
      (tasks) {
        _tasks = tasks;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> createTask(TaskModel task) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTask = await _taskService.createTask(task);
      _tasks.add(newTask);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(String taskId, TaskModel task) async {
    try {
      final updatedTask = await _taskService.updateTask(taskId, task);
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> toggleSubTask(String taskId, int subTaskIndex) async {
    try {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      final updatedSubTasks = List<SubTask>.from(task.subTasks);
      updatedSubTasks[subTaskIndex] = updatedSubTasks[subTaskIndex].copyWith(
        isCompleted: !updatedSubTasks[subTaskIndex].isCompleted,
      );

      final updatedTask = task.copyWith(subTasks: updatedSubTasks);
      await updateTask(taskId, updatedTask);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
