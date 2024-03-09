import 'package:flutter/material.dart';
import 'package:music_player/provider/audio_player_provider.dart';

import 'package:music_player/view/home_screen.dart';
import 'package:provider/provider.dart';

import 'package:audioplayers/audioplayers.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  // final InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid,);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioPlayer>(create: (_) => AudioPlayer()),
        ChangeNotifierProvider<AudioPlayerProvider>(
          create: (context) => AudioPlayerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        title: 'Your App Title',
        home: HomeScreen(),
      ),
    );
  }
}
