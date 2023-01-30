// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_source/shares/local_notify.dart';
import 'package:flutter_source/shares/preferences.dart';
import 'package:flutter_source/shares/sql_lite.dart';
import 'package:flutter_source/src/alarm/model/random_model.dart';

class BackgroundService {
  static Future<void> start() async {
    await FlutterBackgroundService().isRunning().then((value) {
      if (!value) {
        //configure(isForegroundMode: true);
        try {
          FlutterBackgroundService().startService();
        } catch (e) {
          //
        }
      }
    });
  }

  static Future<void> configure() async {
    await FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        initialNotificationTitle: 'Random',
        initialNotificationContent: 'Random is running',
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    final time = await Preferences.getSetting();
    final parse = (double.tryParse(time) ?? 1) * 1000;
    final multi = await Preferences.getMultiRandom();
    Timer? timmer;
    Timer? timmer1;

    if (multi.isNotEmpty) {
      final rs = json.decode(multi);

      timmer =
          Timer.periodic(Duration(milliseconds: parse.toInt()), (timer) async {
        final min = int.tryParse(rs['start'] as String) ?? 0;
        final max = int.tryParse(rs['end'] as String) ?? 0;

        final coin = int.tryParse(rs['coin'] as String) ?? 0;
        final listRandom = <String>[];
        final list = genListRandom(min, max, coin, listRandom);

        await _saveList(list, Sqllite.tableRandomMulti);

        if (_checkList(listRandom, coin > 1)) {
          await LocalNotificationService.display(
            'Kết quả random',
            listRandom.first,
            null,
          );
          timmer?.cancel();
          await service.stopSelf();
        }
      });
    }

    final one = await Preferences.getOneRandom();
    if (one.isNotEmpty) {
      timmer1 =
          Timer.periodic(Duration(milliseconds: parse.toInt()), (timer) async {
        final rs = json.decode(one);
        final min = int.tryParse(rs['start'] as String) ?? 0;
        final max = int.tryParse(rs['end'] as String) ?? 0;
        final coin = int.tryParse(rs['coin'] as String) ?? 0;

        final listRandom = <String>[];
        final list = genListRandom(min, max, coin, listRandom);

        await _saveList(list, Sqllite.tableRandomOne);
        final listNoti = await Preferences.getNotification();
        if (_checkList(listRandom, coin > 1)) {
          if (listNoti.contains(listRandom.first)) {
            await LocalNotificationService.display(
              'Kết quả random',
              listRandom.first,
              null,
            );
            timmer1?.cancel();
            await service.stopSelf();
          }
        }
      });
    }
  }

  static List<RandomList> genListRandom(
    int min,
    int max,
    int coin,
    List<String> listRandom,
  ) {
    final rng = math.Random();
    final listRan = <RandomModel>[];
    final list = <RandomList>[];

    for (var i = 1; i <= coin; i++) {
      final random = (min + rng.nextInt((max + 1) - min)).toString();

      listRan.add(
        RandomModel(
          coin: i.toString(),
          random: random,
        ),
      );
      listRandom.add(random);
      // if (_checkNumber(random)) {
      //   listRandom.add(random);
      // }

      list.add(
        RandomList(
          list: listRan,
          createdAt: DateTime.now(),
        ),
      );
    }

    return list;
  }

  static Future<void> _saveList(List<RandomList> random, String table) async {
    final map = <String, dynamic>{};

    for (var i in random) {
      i.toJson().forEach((key, value) {
        if (value is! String) {
          map[key] = json.encoder.convert(value);
        } else {
          map[key] = value;
        }
      });
    }

    await Sqllite.insert(map, table);
  }

  // static Future<void> _saveList(List<RandomList> random) async {
  //   final map = await FileLocal().readFile();

  //   var list = <RandomList>[];
  //   if (map.isNotEmpty) {
  //     final temp = json.decode(map) as List;
  //     list = temp
  //         .map((e) => RandomList.fromJson(e as Map<String, dynamic>))
  //         .toList();
  //   }

  //   // ignore: cascade_invocations
  //   list.addAll(random);
  //   list = list.reversed.toList();

  //   await FileLocal().writeFile(json.encode(list));
  // }

  // static bool _checkList(List<String> list, int countCoin) {
  //   return list.length == countCoin;
  // }

  static bool _checkList(List<String> list, bool isMulti) {
    if (list.length == 1) {
      if (isMulti) {
        return false;
      }

      return true;
    }

    final temp = list.toSet().toList();
    if (temp.length == 1) {
      return true;
    }
    return false;
  }

  static bool _checkNumber(String number) {
    final list = number.runes.map((int rune) {
      return String.fromCharCode(rune);
    }).toList();

    if (list.length == 1) {
      return false;
    }

    final temp = list.toSet().toList();
    if (temp.length == 1) {
      return true;
    }

    return false;
  }
}
