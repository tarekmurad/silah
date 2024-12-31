import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../l10n/locale_keys.g.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/shared_components/widgets/button_widget.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_dimens.dart';
import '../../../core/styles/assets.dart';
import 'login/bloc/bloc.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _bloc = getIt<LoginBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                Assets.background,
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 165.w,
                        height: 165.w,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(Assets.logo),
                          ),
                          borderRadius:
                              BorderRadius.circular(Dimens.circleRadius),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 125.h,
                    ),
                    Text(
                      LocaleKeys.lbl_log_in_desc.tr(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                          ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.horizontalPadding,
                      ),
                      child: ButtonWidget(
                        onPressed: () {
                          context.router.push(const SignUpRoute());
                          // context.router.push(const VerificationRoute());
                        },
                        labelText: "Sign up",
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.horizontalPadding,
                      ),
                      child: ButtonWidget(
                        onPressed: () {
                          context.router.push(const LoginRoute());
                        },
                        labelText: 'Log in',
                        color: AppColors.whiteColor,
                        borderColor: AppColors.primaryColor,
                        labelColor: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
