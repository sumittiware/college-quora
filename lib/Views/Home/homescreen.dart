import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Services/authservices.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Text(
          "Your are looged in with id : " + userdata.userID,
        ),
      ),
    );
  }
}
