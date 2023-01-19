import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DayCalendar extends StatefulWidget {
  DayCalendar(
    this.solarDay,
    this.lunarDay, {
    required this.thisMonth,
    required this.thisDay,
    this.onTap,
    this.onSelected,
    this.clickStream,
    super.key,
  });

  DateTime solarDay;
  DateTime lunarDay;
  bool thisMonth;
  bool thisDay;
  bool? onSelected;
  final VoidCallback? onTap;
  Stream<DateTime>? clickStream;

  @override
  State<DayCalendar> createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar> {
  Color colorBG = Colors.transparent;
  Color colorText = Colors.black;
  bool onSelected = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    colorBG = widget.thisDay
        ? const Color.fromARGB(255, 224, 242, 228)
        : Colors.transparent;
    colorText = widget.thisDay
        ? Colors.red
        : (widget.thisMonth ? Colors.black : Colors.grey);

    if (widget.onSelected ?? false) {
      colorBG = const Color.fromARGB(255, 78, 186, 103);
      colorText = Colors.white;
    }

    widget.clickStream?.listen(listen);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DayCalendar oldWidget) {
    colorBG = widget.thisDay ? const Color(0xFFe0f2f1) : Colors.transparent;
    colorText = widget.thisDay
        ? Colors.red
        : (widget.thisMonth ? Colors.black : Colors.grey);

    if (widget.onSelected ?? false) {
      colorBG = const Color.fromARGB(255, 78, 186, 103);
      colorText = Colors.white;
    }
    super.didUpdateWidget(oldWidget);
  }

  void listen(DateTime dateTime) {
    if ((dateTime.day != widget.solarDay.day ||
            dateTime.month != widget.solarDay.month ||
            dateTime.year != widget.solarDay.year) &&
        mounted) {
      onSelected = false;
      setState(() {
        if (widget.thisDay) {
          colorBG = const Color.fromARGB(255, 224, 242, 228);
          colorText = Colors.red;
        } else {
          colorBG = Colors.transparent;
          colorText = widget.thisDay
              ? Colors.red
              : (widget.thisMonth ? Colors.black : Colors.grey);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: colorBG),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          onSelected = true;
          widget.onTap?.call();
          if (widget.thisMonth) {
            setState(() {
              colorBG = const Color.fromARGB(255, 78, 186, 103);
              colorText = Colors.white;
            });
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.solarDay.day.toString(),
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: colorText,
                  ),
            ),
            Text(
              '${widget.lunarDay.day}/${widget.lunarDay.month}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorText,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
