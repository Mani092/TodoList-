import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Task {
  RxString title;
  RxString description;
  RxString priority;  // e.g., 'low', 'medium', 'high'
  Rx<DateTime> reminderTime;
  RxBool isChecked; // This should be RxBool

  Task({
    required String title,
    required String description,
    required String priority,
    required DateTime reminderTime,
    bool isChecked = false,  // Default value for isChecked
  })  : title = title.obs,
        description = description.obs,
        priority = priority.obs,
        reminderTime = reminderTime.obs,
        isChecked = RxBool(isChecked);

  int get priorityValue {
    // Access the .value of priority
    switch (priority.value) {  // Corrected to access the value
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
