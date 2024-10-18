import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task.dart';

class TodoController extends GetxController {

  var tasks = <Task>[].obs;
  var isChecked = [].obs;
  var filteredTasks = <Task>[].obs;
  var isTasksLoaded = false.obs; // To track if tasks are loaded

  @override
  void onInit() {
    super.onInit();
    loadTasks(); // Load tasks when the controller is initialized
  }

  // Add item to task list
  void additem(Task title) {
    tasks.add(title);
    isChecked.add(false);
    sortTasks();
    filteredTasks.assignAll(tasks);
    saveTasks(); // Save tasks to SharedPreferences
  }

  // Toggle task completion status
  void toggleTaskCompletion(Task task) {
    task.isChecked.value = !task.isChecked.value;
    saveTasks(); // Save task changes after toggling
  }

  // Sort tasks by priority and reminder time
  void sortTasks() {
    tasks.sort((a, b) {
      int priorityComparison = b.priorityValue.compareTo(a.priorityValue);
      if (priorityComparison == 0) {
        return a.reminderTime.value.compareTo(b.reminderTime.value);
      } else {
        return priorityComparison;
      }
    });
    filterTasks('');
  }

  // Delete item from task list
  void deleteitem(int index) {
    if (tasks.isNotEmpty && index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    }
    filterTasks('');
    saveTasks(); // Save changes after deletion
  }

  // Count pending tasks
  int count2do() {
    return isChecked.where((item) => item == false).length;
  }

  // Edit an existing task
  void edititem(Task task, String newTitle, String newDescription, String newPriority, DateTime newReminderTime) {
    task.title.value = newTitle;
    task.description.value = newDescription;
    task.priority.value = newPriority;
    task.reminderTime.value = newReminderTime;
    tasks.refresh();
    saveTasks(); // Save task changes after editing
  }

  // Filter tasks based on a query
  void filterTasks(String query) {
    if (query.isEmpty) {
      filteredTasks.assignAll(tasks);  // Show all tasks if query is empty
    } else {
      filteredTasks.assignAll(
        tasks.where((task) => task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');

    if (taskList != null) {
      tasks.assignAll(
        taskList.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList(),
      );
    }
    isTasksLoaded.value = true; // Mark tasks as loaded
  }
}
