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
import '../../data/models/confirm_password.dart';
import '../../data/models/password.dart';
import '../widgets/password_text_hint_field_widget.dart';
import 'bloc/bloc.dart';

@RoutePage()
class ResetPasswordPage extends StatefulWidget {
  final String code;
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.code,
    required this.email,
  });

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late ResetPasswordBloc _bloc;
  late GlobalKey _scaffoldKey;

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  Timer? _passwordTimeHandle;
  Timer? _confirmPasswordTimeHandle;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<ResetPasswordBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                      "Reset Password",
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
                      "Set the new password for your account so you can login and access all features.",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.neutral300Color,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) =>
                          previous.password != current.password,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PasswordTextHintFieldWidget(
                              textEditingController: _passwordController,
                              hintText: LocaleKeys.lbl_password.tr(),
                              onChanged: (text) {
                                if (_passwordTimeHandle?.isActive ?? false) {
                                  _passwordTimeHandle!.cancel();
                                }
                                _passwordTimeHandle = Timer(
                                    const Duration(milliseconds: 250), () {
                                  _bloc.add(PasswordChanged(password: text));
                                });
                              },
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (state.password.error ==
                                    PasswordValidationError.empty &&
                                !state.password.isPure)
                              Text(
                                LocaleKeys.err_password_empty.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: 10.sp),
                              )
                            else if (state.password.isNotValid &&
                                state.password.error ==
                                    PasswordValidationError.tooShort)
                              Text(
                                'Password is too short',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: AppColors.redColor,
                                      fontSize: 10.sp,
                                    ),
                              ),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) =>
                          previous.password != current.password ||
                          previous.confirmPassword != current.confirmPassword,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PasswordTextHintFieldWidget(
                              textEditingController: _confirmPasswordController,
                              hintText: "Confirm New Password",
                              onChanged: (text) {
                                if (_confirmPasswordTimeHandle?.isActive ??
                                    false) {
                                  _confirmPasswordTimeHandle!.cancel();
                                }
                                _confirmPasswordTimeHandle = Timer(
                                    const Duration(milliseconds: 250), () {
                                  _bloc.add(ConfirmPasswordChanged(
                                      confirmPassword: text));
                                });
                              },
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (state.confirmPassword.isNotValid &&
                                state.confirmPassword.error ==
                                    ConfirmPasswordValidationError.mismatch)
                              Text(
                                'Confirm password should be the same of password',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: AppColors.redColor,
                                      fontSize: 10.sp,
                                    ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    BlocListener<ResetPasswordBloc, ResetPasswordState>(
                      bloc: _bloc,
                      listenWhen: (previous, current) =>
                          previous.status != current.status,
                      listener: (context, state) {
                        if (state.status.isFailure) {
                          showSnackBar(
                            context,
                            '',
                            AppColors.warningColor,
                          );
                        } else if (state.status.isSuccess) {
                          //// navigate to home
                          context.router.replace(const HomeRoute());
                        }
                      },
                      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          bool isValidated = state.password.isValid &&
                              state.confirmPassword.isValid &&
                              !state.status.isInProgress;

                          return AbsorbPointer(
                            absorbing: !isValidated,
                            child: ButtonWidget(
                              onPressed: () {
                                if (isValidated) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _bloc.add(ResetPasswordSubmitted(
                                      email: widget.email, code: widget.code));
                                }
                              },
                              loading: state.status.isInProgress,
                              labelText: "Reset Password",
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
