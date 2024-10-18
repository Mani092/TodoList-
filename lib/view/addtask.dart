import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todoapp/controller/controller.dart';
import 'package:todoapp/model/notification.dart';

import '../model/task.dart';
class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _disc='';
  String _priority = 'Low';
  DateTime _reminderTime = DateTime.now();

  final TodoController taskController = Get.find();  // Get the TodoController instance
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Task Title'),
              onChanged: (value) {
                _title = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Task Discription'),
              onChanged: (value) {
                _disc = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a discription';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Priority Level'),
              value: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
              items: ['Low', 'Medium', 'High'].map((String priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Reminder Time'),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_reminderTime),
                  );
                  if (time != null) {
                    setState(() {
                      // Update _reminderTime with both date and time
                      _reminderTime = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
              readOnly: true,
              controller: TextEditingController(text: getFormattedDateTime(_reminderTime)),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Task newTask = Task(
                title: _title,
                priority: _priority,
                description: _disc,
                reminderTime: _reminderTime,
              );
              taskController.additem(newTask);
              if(newTask.isChecked!=true){
                DateTime scheduled=_reminderTime;
                DateTime lsrem=scheduled.subtract(Duration(minutes: 30));
                NotificationService.scheduleNotification(
                  0,
                  'The ${_title} will expire in 30 mins',
                  _disc,
                  lsrem,
                );
                NotificationService.scheduleNotification(
                  0,
                  'The ${_title}has expired',
                  _disc,
                  scheduled,
                );
              }

              Get.back();  // Close the dialog
            }
          },
          child: Text('Add Task'),
        ),
      ],
    );
  }
}
