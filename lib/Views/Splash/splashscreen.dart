import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "College Quora ",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          Image(
            image: AssetImage('assets/gifs/Hourglass.gif'),
            height: 70,
            width: 70,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }
}
