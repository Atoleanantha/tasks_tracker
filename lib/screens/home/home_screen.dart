
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/screens/home/bloc/home_bloc.dart';
import 'package:task_tracker/screens/add_task_screen.dart';

import '../edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    homeBloc.add(HomeInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen(homeBloc: homeBloc)),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Task Tracker"),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case HomeLoadingState:
              return Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: const [
                      SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
                      Text("Loading...", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            case HomeErrorState:
              return Container();
            case HomeSuccessState:
              final successState = state as HomeSuccessState;
              if(successState.tasks.isEmpty){
                return const Center(child: Text("No tasks created!"),);
              }
              return ListView.builder(
                itemCount: successState.tasks.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(successState.tasks[index].title +" (${successState.tasks[index].isCompleted? "Completed":"Incomplete"})",style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                        subtitle: Text(successState.tasks[index].description),
                        leading: IconButton(
                          onPressed: () {
                            // Dispatch HomeCompleteTaskEvent with the task to toggle its completion status
                            homeBloc.add(HomeCompleteTaskEvent(taskModel: successState.tasks[index]));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: successState.tasks[index].isCompleted?Text("Marked as impcomplete.", style: TextStyle(color: Colors.red),):Text("Task marked as completed.",style: TextStyle(color: Colors.green),),
                              ),
                            );

                          },
                          icon: const Icon(Icons.done_outline),
                          color: successState.tasks[index].isCompleted ? Colors.green : Colors.black,
                        ),
                        trailing:  Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Navigate to edit screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditTaskScreen(
                                    task: successState.tasks[index],
                                    homeBloc: homeBloc,
                                  )),
                                );
                              },
                              icon: Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text('Are you sure you want to delete this task?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Dispatch delete event if confirmed
                                            homeBloc.add(HomeDeleteTaskEvent(task: successState.tasks[index]));
                                            Navigator.of(context).pop(); // Close dialog
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete_rounded, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1,)
                    ],
                  );

                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
