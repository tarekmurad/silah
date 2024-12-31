import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../features/auth/presentation/forget_password/forget_password_page.dart';
import '../../features/auth/presentation/login/login_page.dart';
import '../../features/auth/presentation/reset_password/reset_password_page.dart';
import '../../features/auth/presentation/signup/sign_up_page.dart';
import '../../features/auth/presentation/verification/admin_approval_page.dart';
import '../../features/auth/presentation/verification/verification_page.dart';
import '../../features/auth/presentation/verify_forget_password/verify_forget_password_page.dart';
import '../../features/auth/presentation/welcome_page.dart';
import '../../features/calendar/presentation/calendar/calendar_page.dart';
import '../../features/home/presentation/screens/home_page.dart';
import '../../features/library/data/models/folder.dart';
import '../../features/library/presentation/library/library_page.dart';
import '../../features/library/presentation/library/downloads_page.dart';
import '../../features/library/presentation/library/favorites_page.dart';
import '../../features/library/presentation/widgets/audio_player.dart';
import '../../features/library/presentation/widgets/pdf_viewer.dart';
import '../../features/library/presentation/widgets/video_player.dart';
import '../../features/profile/presentation/profile/profile_page.dart';
import '../../features/splash/screens/splash.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: WelcomeRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: VerificationRoute.page),
    AutoRoute(page: ForgetPasswordRoute.page),
    AutoRoute(page: VerifyForgetPasswordRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(page: AdminApprovalRoute.page),
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      children: [
        AutoRoute(
          page: CalendarRoute.page,
          path: 'calendar',
        ),
        AutoRoute(
          page: LibraryTabRoute.page,
          path: 'library',
          children: [
            CustomRoute(
              path: '',
              page: LibraryRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              durationInMilliseconds: 200,
            ),
            CustomRoute(
              path: 'folder',
              page: LibraryRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              durationInMilliseconds: 200,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: AudioPlayerRoute.page),
    AutoRoute(page: PdfViewerRoute.page),
    AutoRoute(page: VideoPlayerRoute.page),
    AutoRoute(page: DownloadsRoute.page),
    AutoRoute(page: FavoritesRoute.page),
  ];
}

@RoutePage()
class LibraryTabPage extends AutoRouter {
  const LibraryTabPage({super.key});
}
