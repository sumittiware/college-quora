import 'package:flutter/material.dart';
import 'package:quora/Views/EditorScreen/texteditor.dart';
import 'package:quora/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Text("HomeScreen"),
    ));
  }
}
