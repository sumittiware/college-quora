import 'package:flutter/material.dart';

class CommentController extends TextEditingController {
  static bool ison = false;
  @override
  TextSpan buildTextSpan(
      {BuildContext context, TextStyle style, bool withComposing}) {
    List<InlineSpan> children = [];
    var re = RegExp(r"\B@[a-zA-Z0-9]+\b");
    if (text.contains(re)) {
      children.add(TextSpan(
          style: TextStyle(color: Colors.blue), text: text.substring(2, 6)));
      children.add(TextSpan(text: text.substring(text.indexOf('@'))));
    } else {
      children.add(TextSpan(style: TextStyle(color: Colors.black), text: text));
    }
    return TextSpan(style: style, children: children);
  }
}
