import 'package:auto_route/auto_route.dart';
import 'package:boilerplate_flutter/src/core/styles/app_dimens.dart';
import 'package:boilerplate_flutter/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/navigation/app_router.dart';
import '../../../core/shared_components/widgets/loader_widget.dart';
import '../../../core/styles/assets.dart';
import '../bloc/bloc.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final _bloc = getIt<SplashBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      _bloc.add(GetUserInfo());
    });
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
      backgroundColor: Color(0xff04075F),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              Assets.background,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Container(
              width: 165.w,
              height: 165.w,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Assets.logo),
                ),
                borderRadius: BorderRadius.circular(Dimens.circleRadius),
              ),
            ),
          ),
          BlocListener<SplashBloc, SplashState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is NavigateToHomeScreenState) {
                context.router.replace(const HomeRoute());
              } else if (state is NavigateToSignUpScreenState) {
                context.router.replace(const WelcomeRoute());
              }
            },
            child: BlocBuilder<SplashBloc, SplashState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is LoadingState) {
                  return Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 22.w,
                        height: 22.w,
                        margin: EdgeInsets.symmetric(
                          vertical: 40.w,
                        ),
                        child: Center(
                          child: LoaderWidget(
                            size: 24.w,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
