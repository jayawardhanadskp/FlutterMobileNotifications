import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/firebase_options.dart';
import 'package:notification_app/notifications/local_notifications/local_notifications.dart';
import 'package:notification_app/notifications/push_notifications/push_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'pages/home_page.dart';

// navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the localNotification
  await LocalNotificationsService.init();

  // initialize timezone
  tz.initializeTimeZones();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize push notification service
  await PushNotifications.init();

  // listen for incomming message in background
  FirebaseMessaging.onBackgroundMessage(
    PushNotifications.onBackgroundMessage,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const HomePage(),
      },
    );
  }
}
