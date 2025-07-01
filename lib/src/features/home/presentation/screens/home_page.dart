import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/assets.dart';
import '../../../../injection_container.dart';
import '../bloc/bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = getIt<HomeBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    // _bloc.add(GetUserInfo());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      animationDuration: const Duration(milliseconds: 0),
      animationCurve: Curves.easeIn,
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      routes: [
        const MainRoute(),
        CategoriesRoute(),
        const TodoRoute(),
        const ProfileRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          onTap: (int index) {
            if (tabsRouter.activeIndex == index) {
              final currentRouter = tabsRouter
                  .innerRouterOf<StackRouter>(tabsRouter.current.name);
              if (currentRouter != null && currentRouter.canPop()) {
                currentRouter.popUntilRoot();
              }
            } else {
              tabsRouter.setActiveIndex(index);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(
                  Icons.home_filled,
                  size: 23.w,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: SvgPicture.asset(
                  tabsRouter.activeIndex == 1
                      ? Assets.activeLibNavIcon
                      : Assets.inactiveLibNavIcon,
                  width: 18.w,
                  height: 18.w,
                  colorFilter: ColorFilter.mode(
                    tabsRouter.activeIndex == 1
                        ? AppColors.whiteColor
                        : AppColors.primary400Color,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(
                  Icons.list_alt,
                  size: 23.w,
                ),
              ),
              label: 'To Do',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(
                  Icons.person,
                  size: 23.w,
                ),
              ),
              label: 'Profile',
            ),
          ],
          backgroundColor: AppColors.primaryColor,
          currentIndex: tabsRouter.activeIndex,
          selectedItemColor: AppColors.whiteColor,
          unselectedItemColor: AppColors.primary400Color,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
        );
      },
    );
  }
}
