import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mental_health_chatbot/services/auth.dart';
import 'package:mental_health_chatbot/view/screens/Screen_splash.dart';
import 'package:mental_health_chatbot/view/screens/screen_login.dart';
import 'package:mental_health_chatbot/widgets/custom_error.dart';
import 'package:provider/provider.dart';

import 'constants/colors/colors.dart';
import 'constants/style/style.dart';
import 'models/user.dart';
// Ensure your CustomUser model is correctly imported

Widget build(BuildContext context) {
  // Use StreamProvider with CustomUser to provide authentication state
  return StreamProvider<CustomUser?>.value(
    value: AuthService().user, // Provide the auth state from AuthService
    initialData: null, // Set initial data to null for proper null safety
    child: const MaterialApp(
     // home: ScreenSplash(), // Redirect to the wrapper screen based on auth state
      debugShowCheckedModeBanner: false,
    ),
  );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle the notification in background
  print('Handling a background message: ${message.messageId}');
}


void colorConfig() {
  appPrimaryColor = const MaterialColor(
    0xFF002A8D,
    <int, Color>{
      50: Color(0xFF002A8D),
      100: Color(0xFF002A8D),
      200: Color(0xFF002A8D),
      300: Color(0xFF002A8D),
      400: Color(0xFF002A8D),
      500: Color(0xFF002A8D),
      600: Color(0xFF002A8D),
      700: Color(0xFF002A8D),
      800: Color(0xFF002A8D),
      900: Color(0xFF002A8D),
    },
  );
  appBoxShadow = [const BoxShadow(blurRadius: 18, color: Color(0x414D5678))];
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override



  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground message
      print('Foreground message: ${message.notification?.title}');
      // Show the notification in the app (optional)
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when app is opened from notification
    });
  }
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("message: $message");

    if (message.data['type'] == 'chat') {}
  }

  void setupNotificationChannel() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const settingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? iOS = message.notification?.apple;

      // If onMessage is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    icon: android.smallIcon,
                    enableVibration: true,
                    // importance: Importance.max,
                    priority: Priority.max,
                    // ongoing: false,
                    // autoCancel: true,
                    // visibility: NotificationVisibility.public,
                    enableLights: true
                  // other properties...
                ),
                iOS: DarwinNotificationDetails(
                  sound: iOS?.sound?.name,
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )));

        // showOngoingNotification(flutterLocalNotificationsPlugin, title: notification.title ?? "", body: notification.body ?? "");
      }
    });
  }

  void initNotificationChannel() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    const DarwinInitializationSettings initializationSettingsMacOS =
    DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );

  void checkNotificationPermission() async {
    var settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setupInteractedMessage();
      initNotificationChannel();
      setupNotificationChannel();
    }
  }

  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize:  const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return StreamProvider<CustomUser?>.value(
              value: AuthService().user, // Listen for auth state changes
              initialData: null,
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                home: const ScreenSplash(),
                locale: const Locale('en', 'US'),
                defaultTransition: Transition.fade,
                title: "mental health chatbot",
                theme: ThemeData(
                  fontFamily: 'Poppins',
                  radioTheme: const RadioThemeData(),
                  checkboxTheme: CheckboxThemeData(
                    checkColor: WidgetStateProperty.all(Colors.white),
                    fillColor: WidgetStateProperty.all(appPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(color: Color(0xff585858), width: 1),
                  ),
                  appBarTheme: AppBarTheme(
                    color: Colors.white,
                    elevation: 0,
                    titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                    centerTitle: false,
                    systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarColor: appPrimaryColor),
                    iconTheme: const IconThemeData(color: Colors.black),
                  ),
                  dividerColor: Colors.transparent,
                  scaffoldBackgroundColor: Colors.white, colorScheme: ColorScheme.fromSwatch(primarySwatch: appPrimaryColor).copyWith(surface: const Color(0xFFFAFBFF)),
                ),
                builder: (context, widget) {
                  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                    return CustomError(errorDetails: errorDetails);
                  };
                  return ScrollConfiguration(
                      behavior: NoColorScrollBehavior(), child: widget!);
                  // return widget!;
                  // return ScrollConfiguration(behavior: ScrollBehaviorModified(), child: widget!);
                },
              )
          );
        });
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call initializeApp before using other Firebase services.
//
//   print("Handling a background message: ${message}");
// }

class NoColorScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}