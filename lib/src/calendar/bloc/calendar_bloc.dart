import 'package:bloc/bloc.dart';
import 'package:flutter_source/shares/extension_method/date_utils.dart';
import 'package:flutter_source/shares/extension_method/lunar_calendar.dart';
import 'package:flutter_source/src/calendar/model/date_model.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<CalendarEvent>((event, emit) async {
      if (event is GetListDay) {
        emit(CalendarLoaded(await getListDay(event.date), event.date));
      }
    });
  }

  Future<DateModel> getListDay(DateTime date) async {
    final days = <DateTime>[];
    final lunarDays = <DateTime>[];

    final lastDay = DateUtils().lastDayOfMonth(date);

    for (var i = 1; i <= lastDay.day; i++) {
      final tempDay = DateTime(date.year, date.month, i);
      final tempLunar = CalendarConverter.solarToLunar(
        tempDay.year,
        tempDay.month,
        tempDay.day,
        Timezone.Vietnamese,
      );

      days.add(tempDay);
      lunarDays.add(
        tempLunar,
      );
    }

    final firstDay = days.first;

    for (var i = 1; i < firstDay.weekday; i++) {
      final tempDay = DateTime(firstDay.year, firstDay.month, 1 - i);
      final tempLunar = CalendarConverter.solarToLunar(
        tempDay.year,
        tempDay.month,
        tempDay.day,
        Timezone.Vietnamese,
      );

      days.insert(0, tempDay);
      lunarDays.insert(0, tempLunar);
    }

    final lastDayTemp = days.last;
    for (var i = 1; i <= 7 - lastDayTemp.weekday; i++) {
      final tempDay = DateTime(
        lastDayTemp.year,
        lastDayTemp.month,
        lastDayTemp.day + i,
      );
      final tempLunar = CalendarConverter.solarToLunar(
        tempDay.year,
        tempDay.month,
        tempDay.day,
        Timezone.Vietnamese,
      );

      days.add(tempDay);
      lunarDays.add(tempLunar);
    }

    return DateModel(
      solar: days,
      lunar: lunarDays,
    );
  }
}
