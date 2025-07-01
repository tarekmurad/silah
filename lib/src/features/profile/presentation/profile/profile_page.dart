import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah_connect/src/injection_container.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/shared_components/widgets/divider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../core/utils/global_config.dart';
import '../../../../core/utils/helpers.dart';
import 'bloc/bloc.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _bloc;
  late GlobalKey _scaffoldKey;

  late String circleText;

  @override
  void initState() {
    super.initState();

    _bloc = getIt<ProfileBloc>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    final circles = getIt<GlobalConfig>().currentUser?.circles ?? [];
    final circleNames = circles.map((e) => e.name).toList();
    circleText = circleNames.length == 1
        ? '${circleNames.first} Circle'
        : '${circleNames.join(', ')} Circle';
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
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 275.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 275.h,
                      width: double.infinity,
                      child: SvgPicture.asset(
                        Assets.background,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 275.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x0004075F),
                            Color(0x1104075F),
                            Color(0xdd04075F)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 60.h,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 50.w),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Profile",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: AppColors.whiteColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 26.w,
                                    height: 26.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModal();
                                      },
                                      child: Icon(
                                        Icons.settings,
                                        color: AppColors.whiteColor,
                                        size: 26.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 24.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 100.w,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000.r),
                                  color: AppColors.whiteColor,
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
                                    Icons.person,
                                    size: 50.w,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Helper.capitalizeEachWord(
                                            getIt<GlobalConfig>()
                                                    .currentUser
                                                    ?.name ??
                                                '') ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: AppColors.whiteColor,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  if (getIt<GlobalConfig>().currentUser != null)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 12.w,
                                          width: 12.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(1000.r),
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Flexible(
                                          child: Text(
                                            circleText,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                  color: AppColors.greenColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Study Archive',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.router.push(const FavoritesRoute());
                          },
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Row(
                              children: [
                                Container(
                                  height: 50.w,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: AppColors.primary100Color,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      size: 24.w,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  'Favorites',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18.w,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.router.push(const DownloadsRoute());
                          },
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Row(
                              children: [
                                Container(
                                  height: 50.w,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: AppColors.primary100Color,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.download,
                                      size: 24.w,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  'Downloads',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18.w,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              const DividerWidget(
                color: AppColors.primary200Color,
              ),
              GestureDetector(
                onTap: () {
                  context.router.push(
                    const ChangePasswordRoute(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.password_rounded,
                          color: AppColors.primaryColor,
                          size: 22.w,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Change Password',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const DividerWidget(
                color: AppColors.primary200Color,
              ),
              BlocListener<ProfileBloc, ProfileState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is LogoutSucceed) {
                    context.router.pushAndPopUntil(
                      const WelcomeRoute(),
                      predicate: (_) => false,
                    );
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    _bloc.add(Logout());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: AppColors.primaryColor,
                            size: 22.w,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Logout',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }
}
