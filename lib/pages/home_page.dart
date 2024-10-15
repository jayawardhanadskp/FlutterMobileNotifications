import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/notifications/local_notifications/local_notifications.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                LocalNotificationsService.showInatantNotification(
                    title: 'flutter', body: 'test 1');
              },
              child: const Text('show instsnt noti'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                DateTime durationSample =
                    DateTime.now().add(const Duration(seconds: 5));
                LocalNotificationsService.scheduleNotification(
                  title: 'flut seche',
                  body: 'schedule notification',
                  scheduleDate: durationSample,
                );
              },
              child: const Text('sechedule notification'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  LocalNotificationsService.showRecurringNotification(
                    title: 'Recurring',
                    body: 'recurring notification',
                    time: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      10,
                      0,
                    ), // 10.00
                    day: Day.monday,
                  );
                },
                child: const Text('reurring notification')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  LocalNotificationsService.showBigPictureNotification(
                    title: 'big picture',
                    body: 'big picture notification',
                    imageUrl: '@mipmap/ic_launcher',
                  );
                },
                child: const Text('bigpicture notification'))
          ],
        ),
      ),
    );
  }
}
