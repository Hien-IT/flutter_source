// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_source/shares/file.dart';
import 'package:flutter_source/shares/local_notify.dart';
import 'package:flutter_source/shares/preferences.dart';
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
    // const notificationChannelId = 'random';
    // const notificationId = 2701;

    await FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        // notificationChannelId: notificationChannelId,
        // foregroundServiceNotificationId: notificationId,
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
    final multi = await Preferences.getMultiRandom();
    Timer? timmer;
    if (multi.isNotEmpty) {
      final rs = json.decode(multi);

      timmer = Timer.periodic(Duration(seconds: int.tryParse(time) ?? 1),
          (timer) async {
        final rng = math.Random();
        final min = int.tryParse(rs['start'] as String) ?? 0;
        final max = int.tryParse(rs['end'] as String) ?? 0;

        final coin = int.tryParse(rs['coin'] as String) ?? 0;

        final listRan = <RandomModel>[];
        final list = <RandomList>[];
        for (var i = 1; i <= coin; i++) {
          final random = (min + rng.nextInt((max + 1) - min)).toString();

          if (_checkNumber(random)) {
            listRan.add(
              RandomModel(
                coin: i.toString(),
                random: random,
              ),
            );

            list.add(
              RandomList(
                list: listRan,
                createdAt: DateTime.now(),
              ),
            );
            await _saveList(list);

            await LocalNotificationService.display(
              'Kết quả random',
              random,
              null,
            );
            timmer?.cancel();
            await service.stopSelf();
          }

          listRan.add(
            RandomModel(
              coin: i.toString(),
              random: random,
            ),
          );

          list.add(
            RandomList(
              list: listRan,
              createdAt: DateTime.now(),
            ),
          );
        }

        await _saveList(list);
      });
    }

    final one = await Preferences.getOneRandom();
    if (one.isNotEmpty) {
      final rs = json.decode(one);

      Timer.periodic(Duration(seconds: int.tryParse(time) ?? 1), (timer) async {
        final rng = math.Random();
      });
    }
  }

  static Future<void> _saveList(List<RandomList> random) async {
    final map = await FileLocal().readFile();

    var list = <RandomList>[];
    if (map.isNotEmpty) {
      final temp = json.decode(map) as List;
      list = temp
          .map((e) => RandomList.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // ignore: cascade_invocations
    list.addAll(random);
    list = list.reversed.toList();

    await FileLocal().writeFile(json.encode(list));
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
