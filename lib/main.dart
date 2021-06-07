import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:quora/styles/colors.dart';

import 'Providers/feedsprovider.dart';
import 'Views/EditorScreen/editans.dart';
import 'Views/EditorScreen/texteditor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
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
