part of 'random_multi_bloc.dart';

abstract class RandomMultiState {}

class RandomMultiInitial extends RandomMultiState {}

//class ListRandomMultiLoaded extends RandomMultiState {}

class RandomMultiLoaded extends RandomMultiState {}

class RandomMultiStarted extends RandomMultiState {
  RandomMultiStarted({required this.isStart});
  bool isStart;
}

class RandomMultiTimeChecked extends RandomMultiState {
  RandomMultiTimeChecked({required this.isChecked});
  bool isChecked;
}

class ListRandomMultiLoaded extends RandomMultiState {
  ListRandomMultiLoaded({required this.list});
  List<RandomList> list;
}

class LastRandomMultiLoaded extends RandomMultiState {
  LastRandomMultiLoaded({required this.item});
  List<RandomModel> item;
}
