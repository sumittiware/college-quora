import 'package:flutter/material.dart';
import 'package:quora/styles/colors.dart';

class Heading extends StatelessWidget {
  final String text;
  Heading({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            height: 3,
            width: 37,
            color: AppColors.violet,
          )
        ],
      ),
    );
  }
}
