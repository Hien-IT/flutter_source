part of 'random_one_bloc.dart';

abstract class RandomOneState {}

class RandomOneInitial extends RandomOneState {}

class RandomOneTimeChecked extends RandomOneState {
  RandomOneTimeChecked({required this.isChecked});
  bool isChecked;
}

class RandomOneStarted extends RandomOneState {
  RandomOneStarted({required this.isStart});
  bool isStart;
}

class ListRandomOneLoaded extends RandomOneState {
  ListRandomOneLoaded({required this.list});
  List<RandomList> list;
}

class LastRandomOneLoaded extends RandomOneState {
  LastRandomOneLoaded({required this.item});
  List<RandomModel> item;
}
