import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_dimens.dart';

class PasswordTextHintFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final double? height;
  final double? contentPadding;
  final Color? borderColor;

  const PasswordTextHintFieldWidget({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    this.onChanged,
    this.height,
    this.contentPadding,
    this.borderColor,
  }) : super(key: key);

  @override
  _PasswordTextHintFieldWidgetState createState() =>
      _PasswordTextHintFieldWidgetState();
}

class _PasswordTextHintFieldWidgetState
    extends State<PasswordTextHintFieldWidget> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? Dimens.buttonHeight,
      child: TextFormField(
        // validator: ,
        controller: widget.textEditingController,
        onChanged: (String text) {
          if (widget.onChanged != null) {
            widget.onChanged!(text);
          }
        },
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
            ),
        textInputAction: TextInputAction.done,
        obscureText: !_passwordVisible,
        obscuringCharacter: '●',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: widget.contentPadding ?? 16.w, vertical: 16.h),
          fillColor: Colors.transparent,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.widgetRadius),
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.primary300Color,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.widgetRadius),
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.primaryColor,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: AppColors.primary300Color,
                fontSize: 14.sp,
              ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              size: 20.w,
              color: AppColors.primary300Color,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
