import 'dart:ffi';

import 'package:get/get.dart';

import '../model/task.dart';

class TodoController extends GetxController {

  var tasks = <Task>[].obs;
  var isChecked = [].obs;
  var filteredTasks = <Task>[].obs;
  var etasks = <Task>[].obs;

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

      int priorityComparison = b.priorityValue.compareTo(a.priorityValue);


      if (priorityComparison == 0) {
        return a.reminderTime.value.compareTo(b.reminderTime.value);  // Compare reminder times in ascending order
      } else {
        return priorityComparison;
      }
    });
    filterTasks('');
  }

  void deleteitem(int index) {
    if (tasks.isNotEmpty && index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    } else {
      print("Invalid index or task list is empty");
    }
    filterTasks('');
  }

  int count2do() {
    var checked = isChecked.where((item) => item == false).length;
    return checked;
  }

  void edititem(Task task, String newTitle, String newDescription, String newPriority, DateTime newReminderTime) {
    task.title.value = newTitle;
    task.description.value = newDescription;
    task.priority.value = newPriority;
    task.reminderTime.value = newReminderTime;
    tasks.refresh();  // Refresh the task list
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