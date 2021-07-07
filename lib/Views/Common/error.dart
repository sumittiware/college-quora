import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppError extends StatelessWidget {
  final error;
  AppError({this.error});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/error.svg',
            height: 120,
            width: 120,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            error ?? "Something went wrong!!!",
            style: TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}
