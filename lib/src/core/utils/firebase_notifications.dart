import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../injection_container.dart';
import '../styles/app_colors.dart';
import 'global_config.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

class FirebaseNotifications {
  factory FirebaseNotifications() {
    return _notificationService;
  }

  FirebaseNotifications._internal();

  static final FirebaseNotifications _notificationService =
      FirebaseNotifications._internal();

  late FirebaseMessaging firebaseMessaging;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late AndroidNotificationChannel androidNotificationChannel;

  initFirebase() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Request permission for Firebase Messaging
    firebaseMessaging = FirebaseMessaging.instance;
    final NotificationSettings settings =
        await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      getIt<GlobalConfig>().isNotificationPermissionEnabledFromUser = false;
    }

    androidNotificationChannel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: selectNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    _listenToFirebaseMessaging();
  }

  void _listenToFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('/////// Got a message whilst in the onMessage!');
      checkRemoteMessage(message);
      return;
    });
  }

  void checkRemoteMessage(RemoteMessage message) {
    debugPrint('//// Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
        '//// Message also contained a notification: '
        '${message.notification!.title}',
      );

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showNotification(
          message.notification!.hashCode,
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    }

    // BlocProvider.of<AlarmsBloc>(getIt<AppRouter>().navigatorKey.currentContext!)
    //     .add(
    //   GetActiveAlarms(
    //     currentPage: 0,
    //   ),
    // );
  }

  void showNotification(int hashCode, String title, String body) async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      priority: Priority.max,
      importance: androidNotificationChannel.importance,
      styleInformation: const BigTextStyleInformation(''),
      color: AppColors.primaryColor,
    );

    NotificationDetails platform = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(hashCode, title, body, platform);
  }

  Future selectNotification(String? payload) async {}
}
