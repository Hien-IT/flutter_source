part of 'setting_bloc.dart';

abstract class SettingEvent {}

class SettingEventSave extends SettingEvent {
  SettingEventSave(this.data);
  final String data;
}

class SettingEventLoad extends SettingEvent {}
