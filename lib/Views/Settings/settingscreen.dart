import 'package:flutter/material.dart';
import 'package:quora/styles/colors.dart';

class SettingScreen extends StatefulWidget {
  // const SettingScreen({ Key? key }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Setting"),
        backgroundColor: AppColors.orange,
      ),
      body: Container(),
    );
  }
}
