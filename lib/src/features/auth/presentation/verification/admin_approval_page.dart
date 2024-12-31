import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_dimens.dart';
import 'bloc/bloc.dart';

@RoutePage()
class AdminApprovalPage extends StatefulWidget {
  final bool? newAccount;

  const AdminApprovalPage({
    super.key,
    this.newAccount,
  });

  @override
  _AdminApprovalPageState createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  late VerificationBloc _bloc;
  late GlobalKey _scaffoldKey;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<VerificationBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.router.replace(const WelcomeRoute());
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          leading: IconButton(
            color: AppColors.primaryColor,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 18.w,
            onPressed: () {
              context.router.replace(const WelcomeRoute());
            },
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100.w,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000.r),
                        color: AppColors.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          widget.newAccount == true
                              ? Icons.check_rounded
                              : Icons.person,
                          color: Colors.white,
                          size: 70.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      widget.newAccount == true
                          ? 'Account Created Successfully!'
                          : 'Account Pending Approval',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.newAccount == true
                          ? 'Your account has been successfully created and verified. Please wait for admin approval to access the app.'
                          : 'Your account is currently inactive. Please wait for admin approval to access the app.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
