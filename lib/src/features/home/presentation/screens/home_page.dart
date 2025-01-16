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

    _bloc.add(GetUserInfo());
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
        const CalendarRoute(),
        LibraryRoute(),
        const TodoRoute(),
        const ProfileRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          backgroundColor: AppColors.primaryColor,
          currentIndex: tabsRouter.activeIndex,
          onTap: (int index) {
            tabsRouter.setActiveIndex(index);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Icons.calendar_month),
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset(
                  tabsRouter.activeIndex == 1
                      ? Assets.activeLibNavIcon
                      : Assets.inactiveLibNavIcon,
                  width: 19.w,
                  height: 19.w,
                ),
              ),
              label: 'Library',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Icons.list_alt),
              ),
              label: 'To Do List',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.primary500Color,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
        );
      },
    );
  }
}
