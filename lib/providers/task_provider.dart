import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final NotificationService _notificationService = NotificationService();

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List<dynamic> tasksJson = json.decode(tasksString);
      _tasks = tasksJson.map((json) => Task.fromMap(json)).toList();
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString = json.encode(
      _tasks.map((task) => task.toMap()).toList(),
    );
    await prefs.setString('tasks', tasksString);
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await saveTasks();
    await _scheduleNotification(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await saveTasks();
      await _scheduleNotification(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    _tasks.removeWhere((t) => t.id == id);
    await saveTasks();
    await _notificationService.cancelNotification(task.id.hashCode);
    notifyListeners();
  }

  Future<void> _scheduleNotification(Task task) async {
    if (task.dateTime.isAfter(DateTime.now()) && !task.isCompleted) {
      await _notificationService.scheduleNotification(
        id: task.id.hashCode,
        title: 'تذكير بالمهمة',
        body: task.title,
        scheduledDate: task.dateTime,
      );
    } else {
      await _notificationService.cancelNotification(task.id.hashCode);
    }
  }

  // Clear all data (for logout if needed, though user said persist locally)
  // User said: "When logging out and returning, information is present, stored locally"
  // So we don't clear tasks on logout.
  void clearTasks() {
    _tasks = [];
    notifyListeners();
  }
}
