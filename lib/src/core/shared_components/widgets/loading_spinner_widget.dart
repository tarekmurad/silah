import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/app_colors.dart';
import 'loader_widget.dart';

class LoadingSpinnerWidget extends StatefulWidget {
  const LoadingSpinnerWidget({Key? key}) : super(key: key);

  @override
  _LoadingSpinnerWidgetState createState() => _LoadingSpinnerWidgetState();
}

class _LoadingSpinnerWidgetState extends State<LoadingSpinnerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.whiteColor.withOpacity(0.6),
      child: Center(
        child: LoaderWidget(
          size: 30.w,
        ),
      ),
    );
  }
}
