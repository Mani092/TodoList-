import 'dart:ffi';

import 'package:get/get.dart';

import '../model/task.dart';

class TodoController extends GetxController {

  var tasks = <Task>[].obs;
  var isChecked = [].obs;
  var filteredTasks = <Task>[].obs;

  void additem(Task title) {
    tasks.add(title);
    isChecked.add(false);
    sortTasks();
    filteredTasks.assignAll(tasks);
  }
  void toggleTaskCompletion(Task task) {
    task.isChecked.value = !task.isChecked.value;
  }
  void sortTasks() {
    tasks.sort((a, b) {
      int priorityComparison = a.priorityValue.compareTo(b.priorityValue);
      if (priorityComparison == 0) {
        return a.reminderTime.value.compareTo(b.reminderTime.value); // Compare the values of reminderTime
      } else {
        return priorityComparison; // Sort by priority if different
      }
    });
  }

  void deleteitem(int index) {
    tasks.removeAt(index);
    isChecked.removeAt(index);
  }

  int count2do() {
    var checked = isChecked.where((item) => item == false).length;
    return checked;
  }

  void edititem(value, index) {
    tasks[index] = value;
  }

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
}