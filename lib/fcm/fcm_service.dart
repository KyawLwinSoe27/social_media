import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const localNotificationChannel = "high_importance_channel";
const localNotificationChannelTitle = "High Importance Notification";
const localNotificationChannelDescription =
    "The Channel is used for importance notification";

class FCMService {
  static final FCMService _singleton = FCMService._internal();
  factory FCMService() {
    return _singleton;
  }
  FCMService._internal();

  /// Firebase Messaging Instance
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String deviceToken = "";

  void listenForMessages() async {
    /// request notification permission for IOS foreground notification
    Future requestNotificationPermissionIOS() {
      return firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }

    /// Turn IOS Foreground Notification
    Future turnOnIOSForegroundNotification() {
      return firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    }

    /// Android Initialization Setting
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings("ic_launcher");

    /// Initialization Flutter Local Notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    Future initFlutterLocalNotification() {
      final InitializationSettings initializationSettings =
      InitializationSettings(
          android: initializationSettingsAndroid, iOS: null, macOS: null);
      return flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (payload) {print(payload);});
    }

    /// Android Notification Channel
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        localNotificationChannel, localNotificationChannelTitle,
        description: localNotificationChannelDescription,
        importance: Importance.max);

    /// Create Notification Channel
    Future? registerChannel() {
      return flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    /// FOR IOS Foreground Notificaion
    await requestNotificationPermissionIOS();
    await turnOnIOSForegroundNotification();

    /// FOR Android Foreground Notification
    await initFlutterLocalNotification();
    await registerChannel();

    /// GET Device ID
    firebaseMessaging.getToken().then(
          (fcmToken) => print("FCM Token for device ====> $fcmToken"),
        );

    /// Background Notification Callback State
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      // remoteMessage.data | remoteMessage.notification
      print(
          "User pressed the notification ======> ${remoteMessage.notification?.body}");
    });

    /// When killed App Callback
    firebaseMessaging.getInitialMessage().then((remoteMessage) {
      print("Message Launched ======> ${remoteMessage?.notification?.body}");
    });

    /// When Application Foreground
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? androidNotification =
          remoteMessage.notification?.android;

      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: androidNotification.smallIcon,
          )),
          payload: remoteMessage.data["post_id"].toString(),
        );
      }
    });
  }
}
