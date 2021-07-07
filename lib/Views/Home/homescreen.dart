import 'package:flutter/material.dart';

import 'package:quora/Views/Home/questiondetail.dart';
import 'package:quora/extras/contextkeeper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text("Go to question detail"),
        onPressed: () {
          Navigator.of(ContextKeeper.buildContext)
              .push(MaterialPageRoute(builder: (ctx) {
            return QuestionDetailScreen();
          }));
        },
      ),
    ));
  }
}
