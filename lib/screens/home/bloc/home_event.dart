part of 'home_bloc.dart';

@immutable
class HomeEvent {}

class HomeInitialFetchEvent extends HomeEvent{
  
}

class HomeCompleteTaskEvent extends HomeEvent{
  final Task taskModel;
  HomeCompleteTaskEvent({required this.taskModel});
}
class HomeAddTaskEvent extends HomeEvent{
  final Task taskModel;
  HomeAddTaskEvent({required this.taskModel});
}
class HomeEditTaskEvent extends HomeEvent{
  final Task task;
  HomeEditTaskEvent({required this.task});

}

class HomeDeleteTaskEvent extends HomeEvent{
  final Task task;
  HomeDeleteTaskEvent({required this.task});
}
