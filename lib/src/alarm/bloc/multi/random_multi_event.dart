part of 'random_multi_bloc.dart';

abstract class RandomMultiEvent {}

class RandomMultiInit extends RandomMultiEvent {}

class RandomMultiEventStart extends RandomMultiEvent {
  RandomMultiEventStart({
    required this.start,
    required this.end,
    required this.coin,
  });

  final String start;
  final String end;
  final String coin;
}

class RandomMultiEventStop extends RandomMultiEvent {}

class RandomMultiCheckTime extends RandomMultiEvent {}

class StateChange extends RandomMultiEvent {
  StateChange(this.state);
  final RandomMultiState state;
}

class GetMultiList extends RandomMultiEvent {}
