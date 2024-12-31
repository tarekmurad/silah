import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/app_colors.dart';

class DividerWidget extends StatefulWidget {
  final Color? color;

  const DividerWidget({Key? key, this.color}) : super(key: key);

  @override
  _DividerWidgetState createState() => _DividerWidgetState();
}

class _DividerWidgetState extends State<DividerWidget> {
  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 1.h, color: widget.color ?? AppColors.lightWhiteColor);
  }
}
