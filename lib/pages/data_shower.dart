import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DataShower extends StatelessWidget {
  DataShower({super.key});

  // payload data from the notification
  Map<String, dynamic> payload = {};

  @override
  Widget build(BuildContext context) {
    // get payload data from the notification
    final data = ModalRoute.of(context)!.settings.arguments;

    // background push notification tracking
    if (data is RemoteMessage) {
      payload = data.data;
    }

    // foreground push notification tracking
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(payload.toString()),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Name: ${payload['name']}',
              style: const TextStyle(color: Colors.black),
            ),
            Text('Age: ${payload['age']}')
          ],
        ),
      ),
    );
  }
}
