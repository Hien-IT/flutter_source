import 'package:bloc/bloc.dart';
import 'package:flutter_source/shares/preferences.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<SettingEvent>((event, emit) async {
      if (event is SettingEventLoad) {
        final rs = await getSetting();

        emit(SettingLoaded(rs));
      } else if (event is SettingEventSave) {
        await saveSetting(event.data);
      }
    });
  }

  Future<String> getSetting() async {
    return Preferences.getSetting();
  }

  Future<void> saveSetting(String data) async {
    return Preferences.saveSetting(data);
  }
}
