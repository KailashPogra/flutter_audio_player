import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void kShowNotification(String title, String artist) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'music_player',
    'Music Player',
    importance: Importance.max,
    playSound: false,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'music_player',
    'Music Player',
    importance: Importance.max,
    playSound: false,
    enableVibration: false,
    enableLights: false,
    onlyAlertOnce: true,
    channelShowBadge: false,
    showWhen: false,
    ongoing: true,
    //  actions: [
    // AndroidNotificationAction(
    //   'action_previous',
    //   'Previous',
    //   //  icon: 'drawable/ic_skip_previous',
    // ),
    // AndroidNotificationAction(
    //   'action_pause',
    //   'Pause',
    //   // icon: 'drawable/ic_pause',
    // ),
    // AndroidNotificationAction(
    //   'action_next',
    //   'Next',
    //   // icon: 'drawable/ic_skip_next',
    // ),
    //  ],
  );

  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    artist,
    platformChannelSpecifics,
    payload: '',
  );
}
