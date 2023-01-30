import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_source/app/config.dart';
import 'package:flutter_source/shares/backgroud_service.dart';
import 'package:flutter_source/shares/preferences.dart';
import 'package:flutter_source/shares/sql_lite.dart';
import 'package:flutter_source/src/alarm/model/random_model.dart';

part 'random_multi_event.dart';
part 'random_multi_state.dart';

class RandomMultiBloc extends Bloc<RandomMultiEvent, RandomMultiState> {
  RandomMultiBloc() : super(RandomMultiInitial()) {
    on<RandomMultiEvent>((event, emit) async {
      if (event is RandomMultiInit) {
      } else if (event is RandomMultiEventStart) {
        await start(event.start, event.end, event.coin);
        await startTimer();
        AppConfig.isMultiStart = true;
        emit(RandomMultiStarted(isStart: true));
      } else if (event is RandomMultiEventStop) {
        stop();
        stopTimer();
        AppConfig.isMultiStart = false;
        emit(RandomMultiStarted(isStart: false));
      } else if (event is RandomMultiCheckTime) {
        emit(RandomMultiTimeChecked(isChecked: await checkTime()));
      } else if (event is StateChange) {
        emit(event.state);
      } else if (event is GetMultiList) {
        await getListRandom();
      }
    });
  }

  Timer? timer;

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  Future<void> getListRandom() async {
    final map = await Sqllite.queryAllRows(Sqllite.tableRandomMulti);
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
        add(StateChange(LastRandomMultiLoaded(item: list.first.list ?? [])));
      }
    }
    add(StateChange(ListRandomMultiLoaded(list: list)));
  }

  // Future<void> getListRandom() async {
  //   final map = await FileLocal().readFile();

  //   var list = <RandomList>[];
  //   if (map.isNotEmpty) {
  //     final temp = json.decode(map) as List;
  //     list = temp
  //         .map((e) => RandomList.fromJson(e as Map<String, dynamic>))
  //         .toList();

  //     if (list.isNotEmpty) {
  //       add(StateChange(LastRandomMultiLoaded(item: list.first.list ?? [])));
  //     }
  //   }

  //   add(StateChange(ListRandomMultiLoaded(list: list)));
  // }

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
            add(StateChange(RandomMultiStarted(isStart: false)));
            Future.delayed(const Duration(milliseconds: 100), () async {
              await getListRandom();
            });
          }
        });
      },
    );
  }

  Future<bool> checkTime() async {
    final setting = await Preferences.getSetting();
    return setting.isNotEmpty;
  }

  void stop() {
    if (!AppConfig.isOneStart) {
      FlutterBackgroundService().invoke('stopService');
    }
  }

  Future<void> start(
    String start,
    String end,
    String coins,
  ) async {
    await Preferences.saveMultiRandom(
      json.encode({
        'start': start,
        'end': end,
        'coin': coins,
      }),
    );

    await BackgroundService.start();
  }
}
