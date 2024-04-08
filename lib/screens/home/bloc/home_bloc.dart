import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/task.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialFetchEvent>(homeInitialFetchEvent);
    on<HomeCompleteTaskEvent>(homeCompleteTaskEvent);
    on<HomeDeleteTaskEvent>(homeDeleteTaskEvent);
    on<HomeAddTaskEvent>(homeAddTaskEvent);
    on<HomeEditTaskEvent>(homeEditTaskEvent);
  }

  static const _key = 'tasks';
  List<Task> tasks = [];


  FutureOr<void> homeInitialFetchEvent(
      HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? tasksJson = prefs.getStringList(_key);
      if (tasksJson == null) {
        emit(HomeSuccessState(tasks: []));
        return;
      }

      List<Task> tasks = tasksJson
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
      emit(HomeSuccessState(tasks: tasks));
    } catch (e) {
      log("Error in Initial Fetch Method: $e");
      emit(HomeErrorState());
    }
  }

  FutureOr<void> homeAddTaskEvent(
      HomeAddTaskEvent event, Emitter<HomeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> tasksJson = prefs.getStringList(_key) ?? [];
      final json = event.taskModel.toJson();
      tasksJson.add(jsonEncode(json)); // Convert task to JSON before adding
      await prefs.setStringList(_key, tasksJson);

      List<Task> tasks = tasksJson
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
      emit(HomeSuccessState(tasks: tasks));
    } catch (e) {
      log("Error in add task Method: $e");
    }
  }


  FutureOr<void> homeCompleteTaskEvent(
      HomeCompleteTaskEvent event, Emitter<HomeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> tasksJson = prefs.getStringList(_key) ?? [];
      final index = tasksJson.indexWhere((t) => Task.fromJson(jsonDecode(t)).title == event.taskModel.title);
      if (index != -1) {
        final Task task = Task.fromJson(jsonDecode(tasksJson[index]));
        // Toggle the completion status of the task
        task.isCompleted = !task.isCompleted;
        tasksJson[index] = jsonEncode(task.toJson());
        await prefs.setStringList(_key, tasksJson);
      }
      add(HomeInitialFetchEvent());
    } catch (e) {
      log("Error in Complete Task Method: $e");
    }
  }

  FutureOr<void> homeDeleteTaskEvent(
      HomeDeleteTaskEvent event, Emitter<HomeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> tasksJson = prefs.getStringList(_key) ?? [];
      tasksJson.removeWhere((t) => Task.fromJson(jsonDecode(t)).title == event.task.title);
      await prefs.setStringList(_key, tasksJson);
      emit(HomeSuccessState(tasks: tasksJson.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList()));
    } catch (e) {
      log("Error in delete task method: $e");
    }
  }

  FutureOr<void> homeEditTaskEvent(
      HomeEditTaskEvent event, Emitter<HomeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> tasksJson = prefs.getStringList(_key) ?? [];

      // Find and remove the original task from the list
      tasksJson.removeWhere((t) => Task.fromJson(jsonDecode(t)).title == event.task.title);

      // Add the edited task to the list
      tasksJson.add(jsonEncode(event.task.toJson()));

      // Update the tasks list in SharedPreferences
      await prefs.setStringList(_key, tasksJson);

      // Convert JSON strings back to Task objects
      List<Task> tasks = tasksJson.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList();

      // Emit a new HomeSuccessState with the updated list of tasks
      emit(HomeSuccessState(tasks: tasks));
    } catch (e) {
      log("Error in edit task method: $e");
    }
  }



}