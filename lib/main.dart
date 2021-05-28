import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Providers/appproviders.dart';
import 'package:quora/Providers/userProvider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Auth/completeprofile.dart';
import 'package:quora/Views/Auth/signin.dart';
import 'package:quora/Views/Auth/signup.dart';
import 'package:quora/Views/Common/tabscreen.dart';
import 'package:quora/styles/colors.dart';

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
        ChangeNotifierProvider.value(value: AppProviders()),
        ChangeNotifierProvider.value(value: UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quora',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: TabScreen(),
        // home: FutureBuilder(
        //     future: Provider.of<Auth>(context).tryAutoLogin(),
        //     builder: (context, snapshot) {
        //       return (snapshot.data)
        //           ? CompleteYourProfile(null)
        //           : SignUPScreen();
        //     }),
        routes: {
          "/editor": (context) => EditorPage(),
          SignUPScreen.routename: (ctx) => SignUPScreen(),
          SignInScreen.routename: (ctx) => SignInScreen(),
          CompleteYourProfile.routename: (ctx) => CompleteYourProfile(null)
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Quick Start")),
      body: Center(
        child: ElevatedButton(
          child: Text("Open editor"),
          onPressed: () => navigator.pushNamed("/editor"),
        ),
      ),
    );
  }
}
