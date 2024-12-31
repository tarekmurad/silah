import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/l10n/locale_keys.g.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/button_widget.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_dimens.dart';
import '../../../../core/utils/utils.dart';
import '../../data/models/email.dart';
import '../widgets/text_hint_field_widget.dart';
import 'bloc/bloc.dart';

@RoutePage()
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late ForgetPasswordBloc _bloc;
  late GlobalKey _scaffoldKey;

  late TextEditingController _emailController;

  Timer? _emailTimeHandle;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<ForgetPasswordBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                      LocaleKeys.lbl_forget_password.tr(),
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
                      "Enter your email address to begin the verification process. A 4-digit code will be sent to your email for account recovery.",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.neutral300Color,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) =>
                          previous.email != current.email,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHintFieldWidget(
                              textEditingController: _emailController,
                              hintText: LocaleKeys.lbl_email.tr(),
                              onChanged: (text) {
                                if (_emailTimeHandle?.isActive ?? false) {
                                  _emailTimeHandle!.cancel();
                                }
                                _emailTimeHandle = Timer(
                                    const Duration(milliseconds: 250), () {
                                  _bloc.add(LoginEmailChanged(email: text));
                                });
                              },
                              borderColor: state.email.isNotValid &&
                                      state.email.error ==
                                          EmailValidationError.invalid
                                  ? AppColors.redColor
                                  : null,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (state.email.error ==
                                    EmailValidationError.empty &&
                                !state.email.isPure)
                              Text(
                                LocaleKeys.err_email_empty.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 10.sp,
                                    ),
                              )
                            else if (state.email.isNotValid &&
                                state.email.error ==
                                    EmailValidationError.invalid)
                              Text(
                                LocaleKeys.err_email_incorrect.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: AppColors.redColor,
                                      fontSize: 10.sp,
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
                    BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
                      bloc: _bloc,
                      listenWhen: (previous, current) =>
                          previous.status != current.status,
                      listener: (context, state) {
                        if (state.status.isFailure) {
                          showSnackBar(
                            context,
                            state.exceptionError ??
                                LocaleKeys.err_login_failed.tr(),
                            AppColors.warningColor,
                          );
                        } else if (state.status.isSuccess) {
                          context.router.push(VerifyForgetPasswordRoute(
                              email: _emailController.text));
                        }
                      },
                      child:
                          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          bool isValidated =
                              state.email.isValid && !state.status.isInProgress;

                          return AbsorbPointer(
                            absorbing: !isValidated,
                            child: ButtonWidget(
                              onPressed: () {
                                if (isValidated) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _bloc.add(ForgetPasswordSubmitted());
                                }
                              },
                              loading: state.status.isInProgress,
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
