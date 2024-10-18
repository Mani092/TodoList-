import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import 'addtask.dart';
import 'edittask.dart';

var valuecontroller = TextEditingController();

class Todo extends StatefulWidget {
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TodoController taskController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search tasks...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Update the filtered tasks based on the search query
                taskController.filterTasks(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: taskController.filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = taskController.filteredTasks[index];
                  return ListTile(
                    leading: Obx(() => Checkbox(
                      value: task.isChecked.value,  // Use .value to get the current state
                      onChanged: (value) {
                        taskController.toggleTaskCompletion(task);  // Toggle the isChecked state
                      },
                    )),
                    title: Obx(() => Text(
                      task.title.value,
                      style: TextStyle(
                        decoration: task.isChecked.value
                            ? TextDecoration.lineThrough  // Strike-through if task is completed
                            : TextDecoration.none,
                      ),
                    )),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.dialog(EditTaskDialog(index: index, task: task));
                            },

                            icon: Icon(Icons.edit_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              taskController.deleteitem(index);
                              print(index);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    subtitle: Obx(() => Text(
                      'Description: ${task.description.value}\nPriority: ${task.priority.value} | Reminder: ${task.reminderTime.value}',
                    )),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(AddTaskDialog());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}