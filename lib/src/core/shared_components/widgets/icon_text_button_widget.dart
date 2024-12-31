import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_dimens.dart';

class IconTextButtonWidget extends StatefulWidget {
  final String labelText;
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;
  final Color? labelTextColor;
  final Color? borderColor;

  const IconTextButtonWidget({
    Key? key,
    required this.labelText,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.labelTextColor,
    this.borderColor,
  }) : super(key: key);

  @override
  _IconTextButtonWidgetState createState() => _IconTextButtonWidgetState();
}

class _IconTextButtonWidgetState extends State<IconTextButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          foregroundColor: AppColors.whiteColor.withOpacity(0.5),
          shadowColor: AppColors.whiteColor.withOpacity(0),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.itemRadius),
            side: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: 0.5.h,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon,
            SizedBox(width: 10.w),
            Text(
              widget.labelText,
              style: TextStyle(
                color: widget.labelTextColor ?? AppColors.whiteColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
