import 'package:boilerplate_flutter/src/features/auth/presentation/login/bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/constants.dart';
import 'core/navigation/app_router.dart';
import 'core/styles/app_theme.dart';
import 'core/utils/global_config.dart';
import 'injection_container.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    _appRouter = getIt<AppRouter>();

    _fetchLocale().then((locale) {
      context.setLocale(locale);
    });

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<LoginBloc>(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          // theme: AppThemeData.darkThemeData.copyWith(
          //   pageTransitionsTheme: const PageTransitionsTheme(
          //     builders: {
          //       TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
          //       TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          //     },
          //   ),
          // ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1,
              ),
              child: child!,
            );
          },
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppThemeData.lightThemeData,
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }

  Future<Locale> _fetchLocale() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(Constants.applicationLanguage) == null) {
      getIt<GlobalConfig>().currentLanguage = Constants.englishLanguage;
    } else {
      final String? currentLanguage =
          prefs.getString(Constants.applicationLanguage);
      getIt<GlobalConfig>().currentLanguage = currentLanguage!;
    }

    return Locale(getIt<GlobalConfig>().currentLanguage);
  }
}
