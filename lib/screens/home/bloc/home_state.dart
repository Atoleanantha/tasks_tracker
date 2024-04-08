part of 'home_bloc.dart';

@immutable
class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState{}

class HomeErrorState extends HomeState{}

class HomeSuccessState extends HomeState{
   final List<Task> tasks;
   HomeSuccessState({
     required this.tasks,
});
}