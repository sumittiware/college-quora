import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppError extends StatelessWidget {
  final error;
  AppError({this.error});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/svgs/error.svg',
          height: 90,
          width: 90,
        ),
        Text(error ?? "Something went wrong!!!")
      ],
    );
  }
}
