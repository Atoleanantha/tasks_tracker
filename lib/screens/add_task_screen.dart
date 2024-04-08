// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:task_tracker/screens/home/bloc/home_bloc.dart';

import '../model/task.dart';


class AddTaskScreen extends StatefulWidget {
  final HomeBloc homeBloc;
  AddTaskScreen({super.key, required this.homeBloc});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(

                border:OutlineInputBorder(borderRadius: BorderRadius.circular(12),gapPadding: 5),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 10,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border:OutlineInputBorder(borderRadius: BorderRadius.circular(12),gapPadding: 5),
                labelText: 'Description',

              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {

                  widget.homeBloc.add(HomeAddTaskEvent(
                      taskModel: Task(
                          title: _titleController.text,
                        description: _descriptionController.text
                      )));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      content: Text('Task added successfully!',),
                    ),
                  );
                  Navigator.pop(context);

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Please fill all fields.'),
                    ),
                  );
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
