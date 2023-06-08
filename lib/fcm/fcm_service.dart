import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
const localNotificationChannel = "high_importance_channel";
const localNotificationChannelTitle = "High Importance Notifications";
const localNotificationChannelDescription =
    "This channel is used for important notifications.";

class FCMService{
  static final FCMService _singleton = FCMService._internal();

  factory FCMService(){
    return _singleton;
  }
  FCMService._internal();
///Firebase Messaging Instance
FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Flutter Notification Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ///1 Android Initialization Settings
  AndroidInitializationSettings initializationSettingsAndroid = const
  AndroidInitializationSettings('flutter_logo');

  /// 2 Android Notification Channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    localNotificationChannel,
    localNotificationChannelTitle,
    description: localNotificationChannelDescription,
    importance: Importance.max,
  );


void listenForMessages() async{

  //2
  await initFlutterLocalNotification();
  await registerChannel();



  messaging.getToken().then((fcmToken){
    debugPrint("FCM Token for Device ---> ${fcmToken}");
  });

  ///application background state
  FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
    debugPrint(
        "User pressed the notification ${remoteMessage.data['post_id']}");
  });

  ///application kill state
  messaging.getInitialMessage().then((remoteMessage) {
    debugPrint(
        "Message Launched ${remoteMessage?.data['post_id']}");
  });



  /// application foreground
  FirebaseMessaging.onMessage.listen((remoteMessage) async {
    debugPrint("application foreground callback method");
    _handleNotificationPayload(remoteMessage.data['post_id']);
    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? android = remoteMessage.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
        payload: remoteMessage.data['post_id'].toString(),
      );
    }


  });


}

  void _handleNotificationPayload(Map<String, dynamic> payload) {
    // Handle the notification payload
    debugPrint('Notification Payload: ${payload}');

    // Perform desired actions based on the notification payload
    // ...
  }

  Future initFlutterLocalNotification() {
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );
    return flutterLocalNotificationsPlugin.initialize(
        initializationSettings);

  }

  Future? registerChannel() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

}
