import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static Future<void> requestPermissionLocalNotificatinos() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // Ios

    // Both
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }
}
