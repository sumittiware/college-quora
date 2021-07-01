import 'package:flutter/material.dart';
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

void connectToServer() {
  print("inside connect and listen");
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectToServer();
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
          theme:
              ThemeData(primarySwatch: Colors.orange, fontFamily: "Montserrat"),
          // home: TabScreen(),
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
            // "/edit": (ctx) => EditQuestionPage(),
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
