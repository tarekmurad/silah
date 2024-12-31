import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

void showSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor, {
  Color textColor = AppColors.whiteColor,
  Duration duration = const Duration(milliseconds: 3000),
  FlushbarPosition flushBarPosition = FlushbarPosition.TOP,
}) {
  Flushbar(
    messageText: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: textColor),
    ),
    flushbarStyle: FlushbarStyle.GROUNDED,
    animationDuration: const Duration(milliseconds: 300),
    flushbarPosition: flushBarPosition,
    backgroundColor: backgroundColor,
    duration: duration,
  ).show(context);
}
