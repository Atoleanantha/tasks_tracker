import 'package:flutter/material.dart';
import 'package:task_tracker/screens/home/bloc/home_bloc.dart';

import '../model/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final HomeBloc homeBloc;
  const EditTaskScreen({Key? key, required this.task,required this.homeBloc}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleController.text),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField(
            //   controller: _titleController,
            //   decoration: const InputDecoration(
            //     labelText: 'Title',
            //   ),
            // ),
            const SizedBox(height: 16.0),
            Container(
              child: TextField(
                maxLines: 10,
                
                controller: _descriptionController,
                decoration: InputDecoration(
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(12),gapPadding: 5),
                  labelText: 'Description',
                ),
              ),
            ),
           const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save edited task and pop screen
                if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                  Task editedTask = Task(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isCompleted: widget.task.isCompleted,
                  );

                  widget.homeBloc.add(HomeEditTaskEvent(task: editedTask));
                  Navigator.of(context).pop();
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Please fill all fields.'),
                    ),
                  );
                }

              },
              child:const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
