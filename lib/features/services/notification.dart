import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sd_campus_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

// FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  
  // ios initialization
  DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  // DarwinInitializationSettings darwinInitializationSettings =
  //     DarwinInitializationSettings(
  //   onDidReceiveLocalNotification: (id, title, body, payload) {},
  // );
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onSelectNotification: (payload) {
    //_didReceiveLocalNotification(payload);
    //}
  );
}

Future<void> scheduleNotification({required int scheduledTime, required String title, required String body}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'music_notification', // id
      'Music Notification', // title
      channelDescription: 'Notification to play music at a specific time', // description
      icon: "mipmap/ic_launcher",
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true)
      //sound: RawResourceAndroidNotificationSound('sound'),
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // id
    title, //'Music Notification',
    body, //'Tap to play music',
    tz.TZDateTime.now(tz.UTC).add(
      Duration(seconds: scheduledTime),
    ), // scheduled time

    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode:AndroidScheduleMode.exact
    //androidAllowWhileIdle: true,
  );

  // .then((value)
  // .whenComplete(() {
  // print("hello");
  // SharedPreferenceHelper.setBoolean(Preferences.timerisset, false);
  //});
}
// void _didReceiveLocalNotification(String? payload) {
//   SharedPreferenceHelper.setBoolean(Preferences.timerisset, false);
//   print(payload);
//   print(SharedPreferenceHelper.getBoolean(Preferences.timerisset));
// }

void flutter_localnotifcation(RemoteNotification notification) {
  // print("object");
  // print(notification.title);
  // print("object");
  flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          playSound: true,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          styleInformation: const DefaultStyleInformation(true, true),
        ),
      ));
}
