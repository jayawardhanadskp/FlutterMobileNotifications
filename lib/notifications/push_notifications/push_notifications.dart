import 'package:firebase_messaging/firebase_messaging.dart';

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
}
