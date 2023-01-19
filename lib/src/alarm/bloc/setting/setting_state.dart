part of 'setting_bloc.dart';

abstract class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoaded extends SettingState {
  SettingLoaded(this.data);
  final String data;
}
