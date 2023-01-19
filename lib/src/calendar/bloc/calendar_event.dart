part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class GetListDay extends CalendarEvent {
  GetListDay(this.date);
  final DateTime date;
}
