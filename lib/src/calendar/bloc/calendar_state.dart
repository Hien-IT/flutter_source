part of 'calendar_bloc.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  CalendarLoaded(this.dateModel, this.crurentDate);
  final DateModel dateModel;
  final DateTime crurentDate;
}
