import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:quora/Providers/appproviders.dart';
import 'package:quora/Providers/filter.dart';
import 'package:quora/Providers/panelcontroller.dart';
import 'package:quora/Providers/userProvider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Auth/completeprofile.dart';
import 'package:quora/Views/Auth/signin.dart';
import 'package:quora/Views/Auth/signup.dart';
import 'package:quora/Views/Common/tabscreen.dart';
import 'package:quora/Views/Splash/splashscreen.dart';
import 'Providers/feedsprovider.dart';
import 'Views/EditorScreen/editans.dart';
import 'Views/EditorScreen/texteditor.dart';

Socket socket;
String fcmToken;
FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void connectToServer() {
  try {
    socket = io("http://192.168.43.220:8000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.connect().onError((data) => print("HEllo!!"));

    // Handle socket events
    socket.on('connect', (_) => print('connect: ${socket.id}'));
    socket.on('msg', (data) => print(data));
    // socket.on('location', handleLocationListen);
    // socket.on('typing', handleTyping);
    // socket.on('message', handleMessage);
    // socket.on('disconnect', (_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));
  } catch (e) {
    print(e.toString());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    connectToServer();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("A new message!!!"),
                content: Text(
                    'Message also contained a notification: ${message.notification.android}'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Okay"))
                ],
              );
            });
        print('Message also contained a notification: ${message.notification}');
      }
    });
    messaging.getToken().then((token) {
      print(token);
      fcmToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: PanelController()),
        ChangeNotifierProvider.value(value: MyFeeds()),
        ChangeNotifierProvider.value(value: Filter()),
        ChangeNotifierProvider.value(value: AppProviders()),
        ChangeNotifierProvider.value(value: UserProvider())
      ],
      child: Consumer<Auth>(
        builder: (context, authdata, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Quora',
          theme: ThemeData(primarySwatch: Colors.orange, fontFamily: "Roboto"),
          home: (authdata.isAuth)
              ? TabScreen()
              : FutureBuilder(
                  future: authdata.tryAutoLogin(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? SplashScreen()
                        : SignUPScreen();
                  }),
          routes: {
            TabScreen.routename: (ctx) => TabScreen(),
            EditQuestionPage.routename: (context) => EditQuestionPage(),
            "/editor": (context) => EditorPage(),
            SignUPScreen.routename: (ctx) => SignUPScreen(),
            SignInScreen.routename: (ctx) => SignInScreen(),
            CompleteYourProfile.routename: (ctx) => CompleteYourProfile(null)
          },
        ),
      ),
    );
  }
}
