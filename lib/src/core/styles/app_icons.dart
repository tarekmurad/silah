import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppIcons {
  AppIcons._();

  static Icon backIcon = Icon(
    Icons.arrow_back_ios_new,
    size: 20.w,
  );

  static Icon addIcon = Icon(
    Icons.add,
    size: 28.w,
  );

  static Icon closeIcon = Icon(
    Icons.expand_more,
    color: AppColors.grayColor,
    size: 28.w,
  );
}
