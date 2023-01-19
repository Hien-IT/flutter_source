import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> initialize() async {
    await _configureLocalTimeZone();

    await requestIOSPermissions();

    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: initializationSettingsIOS,
    );

    final detail =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (detail != null && detail.didNotificationLaunchApp) {
      onNotifications.add(detail.payload);
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
  }

  static Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<NotificationDetails> infoNotification() async {
    const androidPlatformChannelSpecifics =
        AndroidNotificationDetails('fcm', 'FCM', importance: Importance.max);

    // var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    // 'fcm', 'FCM', 'Firebase Cloud Messaging',
    // importance: Importance.max);

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    return const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  static Future<void> display(
    String title,
    String body,
    String? payLoad,
  ) async {
    try {
      NotificationDetails detail;

      detail = await infoNotification();

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        detail,
        payload: payLoad,
      );
    } catch (e) {
      // ignored, really.
    }
  }

  static Future<void> displayWithDateTime(
    String title,
    String body,
    String? payLoad,
    DateTime dateTime,
  ) async {
    try {
      NotificationDetails detail;

      detail = await infoNotification();

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        detail,
        androidAllowWhileIdle: true,
        payload: payLoad,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } catch (e) {
      // ignored, really.
    }
  }
}
