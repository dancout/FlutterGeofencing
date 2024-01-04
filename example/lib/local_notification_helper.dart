// import 'package:atc_flutter/utils/logger/atc_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class LocalNotificationHelper {
  LocalNotificationHelper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static LocalNotificationHelper? _instance;
  static LocalNotificationHelper get instance {
    return _instance ??= LocalNotificationHelper._();
  }

  Future initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_thumbnail_placeholder');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      // AtcLogger.instance.log(Level.debug, 'Notification payload: $payload');
    }
  }

  Future<void> showNotification({
    required String title,
    String? body,
  }) async {
    final uuid = const Uuid().v4();
    final androidNotificationDetails = AndroidNotificationDetails(uuid, uuid,
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    final darwinNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: 'plainCategory', threadIdentifier: uuid);
    final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(1, title, body, notificationDetails, payload: 'item x');
  }
}
