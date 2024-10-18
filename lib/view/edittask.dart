import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todoapp/controller/controller.dart';

import '../model/task.dart';

class EditTaskDialog extends StatefulWidget {
  final int index;
  final Task task;

  EditTaskDialog({required this.index, required this.task});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _priority;
  late String _disc;
    late DateTime _reminderTime;

  final TodoController taskController = Get.find();

  @override
  void initState() {
    super.initState();
    _title = widget.task.title.value;
    _priority = widget.task.priority.value;
    _disc=widget.task.description.value;
    _reminderTime = widget.task.reminderTime.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Task Title'),
              onSaved: (value) {
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
              initialValue: _disc,
              decoration: InputDecoration(labelText: 'Task Discription'),
              onSaved: (value) {
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
              controller: TextEditingController(text: getFormattedDateTime(_reminderTime!)),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              // Update the task in TaskController
              taskController.edititem(
                Task(
                  title: _title,
                  priority: _priority,
                  description: _disc,
                  reminderTime: _reminderTime,
                ),
                widget.index,
              );

              Get.back();  // Close dialog
            }
          },
          child: Text('Save Changes'),
        ),
      ],
    );
  }
}
