import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

class Task {
  String id;
  RxString title;
  RxString description;
  RxString priority;
  Rx<DateTime> reminderTime;
  RxBool isChecked;

  Task({
    required this.id,
    required String title,
    required String description,
    required String priority,
    required DateTime reminderTime,
    bool isChecked = false,
  })  : title = title.obs,
        description = description.obs,
        priority = priority.obs,
        reminderTime = reminderTime.obs,
        isChecked = isChecked.obs;

  // Convert a Task object to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title.value, // Convert RxString to String
      'description': description.value, // Convert RxString to String
      'priority': priority.value, // Convert RxString to String
      'reminderTime': reminderTime.value.toIso8601String(), // Convert DateTime to String
      'isChecked': isChecked.value, // Convert RxBool to bool
    };
  }

  // Create a Task object from a Map (JSON)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      reminderTime: DateTime.parse(json['reminderTime']),
      isChecked: json['isChecked'],
    );
  }

  int get priorityValue {
    switch (priority.value) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
      default:
        return 1;
    }
  }
}


String getFormattedDateTime(DateTime dateTime) {
  return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);  // Format date
}
