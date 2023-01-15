import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shatarkopanicbtn/components/ripple_wave.dart';
import 'package:shatarkopanicbtn/components/single_button.dart';
import 'package:shatarkopanicbtn/main.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/notificationservice/local_notification_service.dart';
import 'package:shatarkopanicbtn/pages/notification_page.dart';
import '../styles/page_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //++++++++++++++++++++++++++++++++++++++++++++++++++++ create request notification channel+++++++++++++++++++++++++++++++++++++++++++++
  bool isFlutterLocalNotificationsInitialized = false;
  late AndroidNotificationChannel channel2;
  Future<void> createRequestnotification() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel2 = const AndroidNotificationChannel(
      'shatarko-1002', // id
      'Request', // title// description
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel2);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  //button click flag
  bool buttonClickFlag1 = true;
  bool buttonClickFlag2 = true;
  bool buttonClickFlag3 = true;
  //varables
  String userName = '';
  String userId = '';
  //mqtt manager connection

  // MQTTClintManager manager = MQTTClintManager();

  //wish message for user
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  void retriveUserName() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var username = preferences.getString('usernameSP');
    var userid = preferences.getInt('useridSP');
    debugPrint(username);
    setState(() {
      userName = username.toString();
      userId = userid.toString();
    });
    // manager.connect(userName);
  }

  //init function
  @override
  void initState() {
    super.initState();
    retriveUserName();
    createRequestnotification();

    //start

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        log('call this when app is terminated');
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          log("New Notification");
          log("message.data11 ${message.data['name']}");
          if (message.data['name'] == 'request') {
            LocalNotificationService.requestNotification(message);
          } else {
            LocalNotificationService.createanddisplaynotification(message);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationPage(
                  userid: userId,
                ),
              ),
            );
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        log('call this when app is forground');
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data11 ${message.data['name']}");
          if (message.data['name'] == 'request') {
            LocalNotificationService.requestNotification(message);
          } else {
            LocalNotificationService.createanddisplaynotification(message);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => NotificationPage(
            //       userid: userId,
            //     ),
            //   ),
            // );
          }
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        log('call this when app is  in background and not terminated');
        log("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data11 ${message.data['name']}");
          // if (message.data['name'] == 'request') {
          //   LocalNotificationService.requestNotification(message);
          // } else {
          //   LocalNotificationService.createanddisplaynotification(message);
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => NotificationPage(
          //         userid: userId,
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    //end
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Styles.systemUiOverlayStyle);
    Provider.of<UserData>(context, listen: false).getuserNameFSP();
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFF3F8FF), // navigation bar color
        statusBarColor: Color(0xFFF3F8FF), // status bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Styles.backgroundColor,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    //wish text for good morning,good evening
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          greeting(),
                          style: Styles.wishTextStyle,
                        ),
                        GestureDetector(
                            onTap: () {
                              log('tap');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationPage(
                                    userid: userId,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.notifications)),
                      ],
                    ),
                    // Consumer<UserData>(builder: (context, provider, child) {
                    //   return Text(
                    //     provider.userName.toString(),
                    //     style: Styles.userNameTextStyle,
                    //   );
                    // }),
                    Text(
                      userName,
                      style: Styles.userNameTextStyle,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //---------------------------------medical----------------
                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => RippleWave(
                                  id: userId,
                                  imagePath: "lib/images/medical.png",
                                  username: userName,
                                  panictype: 'medical',
                                ),
                              );
                              // log('tap');
                              //sent data via mqtt
                              // var data = json.encode({
                              //   'userName': userName,
                              //   'panicType': 'medical'
                              // });
                              // manager.publish(userName, data);
                              // setState(() {
                              //   buttonClickFlag1 = false;
                              //   log(buttonClickFlag1.toString());
                              //   Future.delayed(const Duration(milliseconds: 100), () {
                              //     setState(() {
                              //       buttonClickFlag1 = true;
                              //     });
                              //   });
                              // });
                            },
                            child: SingleButton(
                              imagePath: 'lib/images/medical.png',
                              btnupColor: buttonClickFlag1 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttonupColor,
                              btndownColor: buttonClickFlag1 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttondownColor,
                              btndownShadow: buttonClickFlag1 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttondownShadow,
                              btntopShadow: buttonClickFlag1 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttontopShadow,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //--------------------------------------fire------------------------
                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => RippleWave(
                                  id: userId,
                                  imagePath: "lib/images/fire.png",
                                  username: userName,
                                  panictype: 'fire',
                                ),
                              );
                              // log('tap');
                              //sent data via mqtt
                              // var data = json.encode(
                              //     {'userName': userName, 'panicType': 'fire'});
                              // manager.publish(userName, data);
                              // setState(() {
                              //   buttonClickFlag2 = false;
                              //   log(buttonClickFlag2.toString());
                              //   Future.delayed(const Duration(seconds: 1), () {
                              //     setState(() {
                              //       buttonClickFlag2 = true;
                              //     });
                              //   });
                              // });
                            },
                            child: SingleButton(
                              imagePath: 'lib/images/fire.png',
                              btnupColor: buttonClickFlag2 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttonupColor,
                              btndownColor: buttonClickFlag2 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttondownColor,
                              btndownShadow: buttonClickFlag2 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttondownShadow,
                              btntopShadow: buttonClickFlag2 == false
                                  ? Styles.backgroundColor
                                  : Styles.buttontopShadow,
                            ),
                          ),
                        ]),
                  ]),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  //-----------------------------------------------panic--------------------------
                  //modal section

                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) => RippleWave(
                      id: userId,
                      imagePath: "lib/images/panic.png",
                      username: userName,
                      panictype: 'panic',
                    ),
                  );
                  // log('tap');
                  //sent data via mqtt
                  // var data =
                  //     json.encode({'userName': userName, 'panicType': 'panic'});
                  // manager.publish(userName, data);
                  // setState(() {
                  //   buttonClickFlag3 = false;
                  //   log(buttonClickFlag3.toString());
                  //   Future.delayed(const Duration(seconds: 1), () {
                  //     setState(() {
                  //       buttonClickFlag3 = true;
                  //     });
                  //   });
                  // });
                },
                child: SingleButton(
                  imagePath: 'lib/images/panic.png',
                  btnupColor: buttonClickFlag3 == false
                      ? Styles.backgroundColor
                      : Styles.buttonupColor,
                  btndownColor: buttonClickFlag3 == false
                      ? Styles.backgroundColor
                      : Styles.buttondownColor,
                  btndownShadow: buttonClickFlag3 == false
                      ? Styles.backgroundColor
                      : Styles.buttondownShadow,
                  btntopShadow: buttonClickFlag3 == false
                      ? Styles.backgroundColor
                      : Styles.buttontopShadow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
