import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/button_widget.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_dimens.dart';
import '../../../../core/utils/utils.dart';
import 'bloc/bloc.dart';

@RoutePage()
class VerifyForgetPasswordPage extends StatefulWidget {
  final String email;

  const VerifyForgetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  _VerifyForgetPasswordPageState createState() =>
      _VerifyForgetPasswordPageState();
}

class _VerifyForgetPasswordPageState extends State<VerifyForgetPasswordPage> {
  late VerifyForgetPasswordBloc _bloc;
  late GlobalKey _scaffoldKey;

  late TextEditingController _confirmationCodeController;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<VerifyForgetPasswordBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _confirmationCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmationCodeController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          color: AppColors.primaryColor,
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 18.w,
          onPressed: () {
            context.router.maybePop();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Enter 6 Digits Code",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      "Enter your email for the verification proccess, we will send 6 digits code to your email.",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.neutral300Color,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    BlocBuilder<VerifyForgetPasswordBloc, VerificationState>(
                      bloc: _bloc,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 56.h,
                              child: PinInputTextField(
                                pinLength: 6,
                                controller: _confirmationCodeController,
                                autoFocus: true,
                                keyboardType: TextInputType.number,
                                onChanged: (String number) {
                                  if (number.length == 6) {
                                    _bloc.add(VerificationCodeChanged(
                                        email: widget.email, code: number));
                                  }
                                },
                                decoration: BoxLooseDecoration(
                                  gapSpace: 8.w,
                                  radius: Radius.circular(15.r),
                                  textStyle: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  strokeColorBuilder: PinListenColorBuilder(
                                    AppColors.primary300Color,
                                    AppColors.primary300Color,
                                  ),
                                  bgColorBuilder: PinListenColorBuilder(
                                    Colors.white,
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    BlocListener<VerifyForgetPasswordBloc, VerificationState>(
                      bloc: _bloc,
                      listener: (context, state) {
                        if (state is VerifyAccountFailedState) {
                          showSnackBar(
                            context,
                            'Verify Account is Failed',
                            AppColors.warningColor,
                          );
                        } else if (state is VerifyAccountSucceedState) {
                          context.router.push(ResetPasswordRoute(
                              code: _confirmationCodeController.text,
                              email: widget.email));
                        }
                      },
                      child: BlocBuilder<VerifyForgetPasswordBloc,
                          VerificationState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          bool isValidated =
                              _confirmationCodeController.text.length == 6;

                          return AbsorbPointer(
                            absorbing: !isValidated,
                            child: ButtonWidget(
                              onPressed: () {
                                if (isValidated) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _bloc.add(VerificationCodeChanged(
                                      email: widget.email,
                                      code: _confirmationCodeController.text));
                                }
                              },
                              loading: state is VerifyAccountLoadingState,
                              labelText: "Continue",
                              labelColor: AppColors.whiteColor,
                              color: isValidated
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor.withOpacity(0.5),
                            ),
                          );
                        },
                      ),
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
