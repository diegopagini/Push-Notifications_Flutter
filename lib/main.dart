import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/local_notifications/local_notifications.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/config/theme/app_theme.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';

/// To use providers.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler); // To handle background messages
  await NotificationsBloc.initializeFCM(); // To use FCM.

  await LocalNotifications
      .initializeLocalNotifications(); // To use Local Notifications

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (_) => NotificationsBloc(
            requestLocalNotificationPermissions:
                LocalNotifications.requestPermissionLocalNotificatinos,
            showLocalNotification: LocalNotifications.showLocalNotification))
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRoutter,
      theme: AppTheme().getTheme(),
      builder: (context, child) =>
          HandleNotificationInteractions(child: child!),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) _handleMessage(initialMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    final messageId =
        message.messageId?.replaceAll(':', '').replaceAll('%', '');
    appRoutter.push('/push-details/$messageId');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
