import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/utils/util_functions.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  // create instance
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // implement response logic
  static Future<void> onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) async {}

  // initialize the notification
  static Future<void> init() async {
    // initialize android settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // initialize ios settings
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    // combine the android & ios settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    // request permission to show notification android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // request permission to show notification ios
  }

  // show notification (instant notification) -------------------------------
  static Future<void> showInatantNotification(
      {required String title, required String body}) async {
    // define the notification
    const NotificationDetails platformChannelSpecifications =
        NotificationDetails(
            // define android notification details
            android: AndroidNotificationDetails("channel_id", "channel_name",
                importance: Importance.max, priority: Priority.high),

            // define ios notification details
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ));

    // .. show the notification
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifications);
  }

  // SHEDULE NOTIFICATION ------------------------------------------------------
  static Future<void> scheduleNotification(
      {required String title,
      required String body,
      required DateTime scheduleDate}) async {
    // define the notification details
    const NotificationDetails platformChannelSpecifications =
        NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max, priority: Priority.high),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // schedule Notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        platformChannelSpecifications,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // RECURRING NOTIFICATION ---------------------------------------------
  static Future<void> showRecurringNotification({
    required String title,
    required String body,
    required DateTime time,
    required Day day,
  }) async {
    // define the notification details
    const NotificationDetails platformChannelSpecifications =
        NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max, priority: Priority.high),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // schedune notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        UtilFunctions().nextInstanceOfTime(time, day),
        platformChannelSpecifications,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // BIG PICTURE NOTIFICATION -----------------------------------------------------------
  static Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String imageUrl,
  }) async {
    // genarate bigpicture style infromation
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(imageUrl),
      largeIcon: DrawableResourceAndroidBitmap(imageUrl),
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    // define the notification details
    NotificationDetails platformChannelSpecifications = NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation),
      iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: [DarwinNotificationAttachment(imageUrl)],
          ),
    );

    // show notifification
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifications,
    );
  }
}
