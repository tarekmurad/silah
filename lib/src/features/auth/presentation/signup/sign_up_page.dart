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
import '../../data/models/name.dart';
import '../../data/models/password.dart';
import '../widgets/password_text_hint_field_widget.dart';
import '../widgets/text_hint_field_widget.dart';
import 'bloc/bloc.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpBloc _bloc;
  late GlobalKey _scaffoldKey;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  Timer? _nameTimeHandle;
  Timer? _emailTimeHandle;
  Timer? _passwordTimeHandle;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<SignUpBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                      "Sign Up",
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
                      "Create a Silah account",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.neutral300Color,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    BlocBuilder<SignUpBloc, SignUpState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) =>
                          previous.name != current.name,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHintFieldWidget(
                              textEditingController: _nameController,
                              hintText: 'Name',
                              onChanged: (text) {
                                if (_nameTimeHandle?.isActive ?? false) {
                                  _nameTimeHandle!.cancel();
                                }
                                _nameTimeHandle = Timer(
                                    const Duration(milliseconds: 250), () {
                                  _bloc.add(SignUpNameChanged(name: text));
                                });
                              },
                              borderColor: state.name.isNotValid &&
                                      state.name.error ==
                                          NameValidationError.invalid
                                  ? AppColors.redColor
                                  : null,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (state.name.error == NameValidationError.empty &&
                                !state.name.isPure)
                              Text(
                                'Enter your name.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 10.sp,
                                    ),
                              )
                            else if (state.name.isNotValid &&
                                state.name.error == NameValidationError.invalid)
                              Text(
                                'Name is incorrect',
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
                    BlocBuilder<SignUpBloc, SignUpState>(
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
                                  _bloc.add(SignUpEmailChanged(email: text));
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
                    BlocBuilder<SignUpBloc, SignUpState>(
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
                                  _bloc.add(
                                      SignUpPasswordChanged(password: text));
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
                    SizedBox(
                      height: 32.h,
                    ),
                    BlocListener<SignUpBloc, SignUpState>(
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
                          context.router.push(VerificationRoute(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text));
                        }
                      },
                      child: BlocBuilder<SignUpBloc, SignUpState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          bool isValidated = state.password.isValid &&
                              state.email.isValid &&
                              state.name.isValid &&
                              !state.status.isInProgress;

                          return AbsorbPointer(
                            absorbing: !isValidated,
                            child: ButtonWidget(
                              onPressed: () {
                                if (isValidated) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _bloc.add(SignUpSubmitted());
                                }
                              },
                              loading: state.status.isInProgress,
                              labelText: "Create Account",
                              labelColor: AppColors.whiteColor,
                              color: isValidated
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor.withOpacity(0.5),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.neutral1000Color,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.router.replace(const LoginRoute());
                          },
                          child: Center(
                            child: Text(
                              "Sign in",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
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
