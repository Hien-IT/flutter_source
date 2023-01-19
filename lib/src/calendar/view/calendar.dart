import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_source/src/calendar/bloc/calendar_bloc.dart';
import 'package:flutter_source/src/calendar/view/component/day_calendar.dart';
import 'package:home_widget/home_widget.dart';

// ignore: must_be_immutable
class CalendarView extends StatefulWidget {
  CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();

  StreamController<DateTime>? clickStreamController;
}

class _CalendarViewState extends State<CalendarView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CalendarBloc()..add(GetListDay(DateTime.now())),
        child: body(context),
      ),
    );
  }

  DateTime? selectedDate;

  Stream<DateTime>? clickStream;

  Widget body(BuildContext context) {
    widget.clickStreamController = StreamController.broadcast();
    clickStream = widget.clickStreamController?.stream;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            if (state is CalendarLoaded) {
              return Column(
                children: [
                  header(context, state),
                  Expanded(
                    child: calendarView(
                      context,
                      state.dateModel.solar,
                      state.dateModel.lunar,
                      state.crurentDate,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget header(BuildContext context, CalendarLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            context.read<CalendarBloc>().add(
                  GetListDay(
                    DateTime(
                      state.crurentDate.year,
                      state.crurentDate.month - 1,
                      state.crurentDate.day,
                    ),
                  ),
                );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        InkWell(
          onTap: () {
            DatePicker.showDatePicker(
              context,
              onConfirm: (date) {
                context.read<CalendarBloc>().add(
                      GetListDay(
                        DateTime(
                          date.year,
                          date.month,
                          date.day,
                        ),
                      ),
                    );
              },
              currentTime: state.crurentDate,
              locale: LocaleType.vi,
            );
          },
          child: Text(
            'Tháng ${state.crurentDate.month}/${state.crurentDate.year}',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
        ),
        IconButton(
          onPressed: () {
            context.read<CalendarBloc>().add(
                  GetListDay(
                    DateTime(
                      state.crurentDate.year,
                      state.crurentDate.month + 1,
                      state.crurentDate.day,
                    ),
                  ),
                );
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget calendarView(
    BuildContext context,
    List<DateTime> solar,
    List<DateTime> lunar,
    DateTime crurentDate,
  ) {
    const dayofWeek = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    final widgets = <Widget>[];
    solar.asMap().forEach((index, value) {
      final thisMonth = value.month == crurentDate.month;
      final thisDay = value.day == DateTime.now().day &&
          value.month == DateTime.now().month &&
          value.year == DateTime.now().year;

      if (thisDay) {
        HomeWidget.saveWidgetData<String>('title', value.toString());
        HomeWidget.saveWidgetData<String>('message', lunar[index].toString());
      }

      widgets.add(
        DayCalendar(
          value,
          lunar[index],
          thisMonth: thisMonth,
          thisDay: thisDay,
          onTap: () {
            selectedDate = value;
            widget.clickStreamController?.add(value);
            if (!thisMonth) {
              context.read<CalendarBloc>().add(
                    GetListDay(
                      DateTime(
                        value.year,
                        value.month,
                        value.day,
                      ),
                    ),
                  );
            }
          },
          clickStream: clickStream,
          onSelected: value == selectedDate,
        ),
      );
    });
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            children: [
              ...dayofWeek.map(
                (e) => Center(
                  child: Text(
                    e,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: e == 'CN'
                              ? Colors.red
                              : (e == 'T7' ? Colors.blue : Colors.black),
                        ),
                  ),
                ),
              ),
              ...widgets
            ],
          ),
        ),
      ],
    );
  }
}
