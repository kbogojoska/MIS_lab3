import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mis_lab_3/providers/favorite_joke_provider.dart';
import 'package:mis_lab_3/services/alarm_exact.dart';
import 'package:mis_lab_3/services/local_notif_service.dart';
import 'package:mis_lab_3/services/notif_service.dart';
import 'package:provider/provider.dart';
import 'package:mis_lab_3/screens/favorite_joke_screen.dart';
import 'screens/joke_types_screen.dart';
import 'screens/jokes_by_type_screen.dart';
import 'screens/random_joke_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initialize();
  tz.initializeTimeZones();
  await LocalNotificationService.initialize();
  if (await ExactAlarmHelper.checkExactAlarmPermission()) {
    await LocalNotificationService.scheduleDailyNotification();
  } else {
    var isGranted = await ExactAlarmHelper.requestExactAlarmPermission();
    if (isGranted) {
      await LocalNotificationService.scheduleDailyNotification();
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: MaterialApp(
        title: 'Joke App',
        initialRoute: '/',
        routes: {
          '/': (context) => const JokeTypesScreen(),
          '/jokes_by_type': (context) => const JokesByTypeScreen(),
          '/random_joke': (context) => const RandomJokeScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
