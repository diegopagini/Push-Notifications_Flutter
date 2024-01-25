import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_app/config/router/app_router.dart';

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
    const initializationSettingsDarwing = DarwinInitializationSettings(
        onDidReceiveLocalNotification: iosShowNotification);
    // Both
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwing);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            onDidReceiveNotificationResponse); // To handle the local notification.
  }

  static void iosShowNotification(
      int id, String? title, String? body, String? data) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName',
        playSound: true, importance: Importance.high, priority: Priority.high);

    const darwrilDetails = DarwinNotificationDetails(presentSound: true);

    const notificationDetails =
        NotificationDetails(android: androidDetails, iOS: darwrilDetails);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // To show the notification.
    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails,
        payload: data);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    appRoutter.push('/push-details/${response.payload}');
  }
}
