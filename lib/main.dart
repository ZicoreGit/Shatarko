import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shatarkopanicbtn/components/bottom_nav_bar.dart';
import 'package:shatarkopanicbtn/firebase_options.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/notificationservice/local_notification_service.dart';
import 'package:shatarkopanicbtn/pages/login_page.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  log('Background handler${message.notification!.title.toString()}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'shatarko-1001', // id
    'Alarm', // title// description
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alarmsound'),
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log('Firebase message token ${fcmToken.toString()}');
  LocalNotificationService.initialize();
  await setupFlutterNotifications();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var username = preferences.getString('usernameSP');
  runApp(ChangeNotifierProvider(
    create: (context) => UserData(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: username == null ? const LogInPage() : const BottomNavBar(),
      // home: RegistrationPage(),
    ),
  ));
}
