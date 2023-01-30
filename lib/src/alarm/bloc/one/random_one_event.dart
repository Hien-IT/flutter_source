part of 'random_one_bloc.dart';

abstract class RandomOneEvent {}

class RandomOneCheckTime extends RandomOneEvent {}

class RandomOneEventStart extends RandomOneEvent {
  RandomOneEventStart({
    required this.start,
    required this.end,
    required this.coin,
  });
  final String start;
  final String end;
  final String coin;
}

class StateChange extends RandomOneEvent {
  StateChange(this.state);
  final RandomOneState state;
}

class GetOneList extends RandomOneEvent {}

class RandomOneEventStop extends RandomOneEvent {}

class SaveNotification extends RandomOneEvent {
  SaveNotification(this.listNotification);
  final List<String> listNotification;
}
