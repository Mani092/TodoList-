import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/controller.dart';
import '../model/task.dart';

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TodoController taskController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedPriority = 'Low';
  DateTime selectedReminderTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Title Text Field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            // Description Text Field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            // Dropdown for Priority
            DropdownButton<String>(
              value: selectedPriority,
              items: ['Low', 'Medium', 'High'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            // Select Reminder Date
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedReminderTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedReminderTime),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedReminderTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text(
                'Select Reminder Time: ${DateFormat('dd-MM-yyyy HH:mm').format(selectedReminderTime)}',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);  // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Add the new task to the task list
            Task newTask = Task(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: titleController.text,
              description: descriptionController.text,
              priority: selectedPriority,
              reminderTime: selectedReminderTime,
            );
            taskController.additem(newTask);  // Add new task
            taskController.saveTasks();  // Save tasks to SharedPreferences
            Navigator.pop(context);  // Close the dialog
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
