import 'package:flutter/material.dart';

class ContextKeeper {
  static BuildContext buildContext;

  void init(BuildContext context) {
    buildContext = context;
  }
}
