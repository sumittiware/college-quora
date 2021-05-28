import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showCustomSnackBar(BuildContext context, String message) {
  Flushbar(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(12),
      duration: Duration(seconds: 5),
      borderRadius: 10,
      message: message)
    ..show(context);
}
