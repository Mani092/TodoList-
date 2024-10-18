import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controller/controller.dart';

import '../model/task.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  EditTaskDialog({required this.task});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final TodoController taskController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedPriority = 'Low';
  DateTime selectedReminderTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Set initial values
    titleController.text = widget.task.title.value;
    descriptionController.text = widget.task.description.value;
    selectedPriority = widget.task.priority.value;
    selectedReminderTime = widget.task.reminderTime.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
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

            // Dropdown for Priority Level
            DropdownButton<String>(
              value: selectedPriority,
              items: ['Low', 'Medium', 'High'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPriority = newValue;
                  });
                }
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
            // Update the task
            taskController.edititem(
              widget.task,
              titleController.text,
              descriptionController.text,
              selectedPriority,
              selectedReminderTime,
            );
            Navigator.pop(context);  // Close the dialog after saving
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
