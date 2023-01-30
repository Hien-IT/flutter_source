import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_source/app/config.dart';
import 'package:flutter_source/shares/backgroud_service.dart';
import 'package:flutter_source/shares/preferences.dart';
import 'package:flutter_source/shares/sql_lite.dart';
import 'package:flutter_source/src/alarm/model/random_model.dart';

part 'random_one_event.dart';
part 'random_one_state.dart';

class RandomOneBloc extends Bloc<RandomOneEvent, RandomOneState> {
  RandomOneBloc() : super(RandomOneInitial()) {
    on<RandomOneEvent>((event, emit) async {
      if (event is RandomOneCheckTime) {
        emit(RandomOneTimeChecked(isChecked: await checkTime()));
      } else if (event is RandomOneEventStart) {
        await start(event.start, event.end, event.coin);
        await startTimer();
        AppConfig.isOneStart = true;
        emit(RandomOneStarted(isStart: true));
      } else if (event is StateChange) {
        emit(event.state);
      } else if (event is GetOneList) {
        await getListRandom();
      } else if (event is RandomOneEventStop) {
        stop();
        stopTimer();
        AppConfig.isOneStart = false;
        emit(RandomOneStarted(isStart: false));
      } else if (event is SaveNotification) {
        await Preferences.saveNotification(event.listNotification);
      }
    });
  }

  Timer? timer;
  Future<bool> checkTime() async {
    final setting = await Preferences.getSetting();
    return setting.isNotEmpty;
  }

  void stop() {
    if (!AppConfig.isMultiStart) {
      FlutterBackgroundService().invoke('stopService');
    }
  }

  Future<void> start(
    String start,
    String end,
    String coins,
  ) async {
    await Preferences.saveOneRandom(
      json.encode({
        'start': start,
        'end': end,
        'coin': coins,
      }),
    );

    await BackgroundService.start();
  }

  Future<void> startTimer() async {
    final time = await Preferences.getSetting();
    final parse = (double.tryParse(time) ?? 1) * 1000;
    timer = Timer.periodic(
      Duration(milliseconds: parse.toInt()),
      (timer) async {
        await getListRandom();

        await FlutterBackgroundService().isRunning().then((value) {
          if (!value) {
            stopTimer();
            add(StateChange(RandomOneStarted(isStart: false)));
            Future.delayed(const Duration(milliseconds: 100), () async {
              await getListRandom();
            });
          }
        });
      },
    );
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  Future<void> getListRandom() async {
    final map = await Sqllite.queryAllRows(Sqllite.tableRandomOne);
    final list = <RandomList>[];
    if (map.isNotEmpty) {
      for (final e in map) {
        if (e['list'] != null) {
          final temp = e['list'] as String;

          final decode = json.decode(temp) as List;

          final listTemp = <RandomModel>[];

          for (final i in decode) {
            final temp = RandomModel.fromJson(i as Map<String, dynamic>);
            listTemp.add(temp);
          }
          final date = e['createdAt'] as String;
          list.add(
            RandomList(list: listTemp, createdAt: DateTime.parse(date)),
          );
        }
      }

      if (list.isNotEmpty) {
        add(StateChange(LastRandomOneLoaded(item: list.first.list ?? [])));
      }
    }
    add(StateChange(ListRandomOneLoaded(list: list)));
  }
}
