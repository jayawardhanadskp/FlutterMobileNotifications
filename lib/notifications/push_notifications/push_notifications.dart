import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/notifications/local_notifications/local_notifications.dart';

class PushNotifications {
  // create and instance of firebase messeging plugin
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // initialize firebase messaging (request permission for notifications)
  static Future<void> init() async {
    // request permitions for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      provisional: false,
    );

    // check if the permitions is granded
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permitions');
    } else {
      print('user declied  permitions');
      return;
    }

    // get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print('token: $token');
  }

  //  listen for incoming notifications
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print('background Message: ${message.notification!.title}');
    }
  }

  // on background notification tapped function
  static Future<void> onBackgroundNotificationTapped(
      RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed("/data-screen", arguments: message);
    } else {
      print("NavigatorState is null, cannot navigate.");
    }
  }

  // handle foreground notification
  static Future<void> onForegroundNotificationTapped(
    RemoteMessage message,
  ) async {
    String payload = jsonEncode(message.data);
    print('got the message in foreground');

    if (message.notification != null) {
      await LocalNotificationsService.showLocalNotificationWithPayload(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payload,
      );

      
    }
  }
}
