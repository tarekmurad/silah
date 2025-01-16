// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AdminApprovalPage]
class AdminApprovalRoute extends PageRouteInfo<AdminApprovalRouteArgs> {
  AdminApprovalRoute({
    Key? key,
    bool? newAccount,
    List<PageRouteInfo>? children,
  }) : super(
          AdminApprovalRoute.name,
          args: AdminApprovalRouteArgs(
            key: key,
            newAccount: newAccount,
          ),
          initialChildren: children,
        );

  static const String name = 'AdminApprovalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminApprovalRouteArgs>(
          orElse: () => const AdminApprovalRouteArgs());
      return AdminApprovalPage(
        key: args.key,
        newAccount: args.newAccount,
      );
    },
  );
}

class AdminApprovalRouteArgs {
  const AdminApprovalRouteArgs({
    this.key,
    this.newAccount,
  });

  final Key? key;

  final bool? newAccount;

  @override
  String toString() {
    return 'AdminApprovalRouteArgs{key: $key, newAccount: $newAccount}';
  }
}

/// generated route for
/// [AudioPlayerPage]
class AudioPlayerRoute extends PageRouteInfo<AudioPlayerRouteArgs> {
  AudioPlayerRoute({
    required Folder file,
    Key? key,
    bool? isDownloadedFile,
    List<PageRouteInfo>? children,
  }) : super(
          AudioPlayerRoute.name,
          args: AudioPlayerRouteArgs(
            file: file,
            key: key,
            isDownloadedFile: isDownloadedFile,
          ),
          initialChildren: children,
        );

  static const String name = 'AudioPlayerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AudioPlayerRouteArgs>();
      return AudioPlayerPage(
        file: args.file,
        key: args.key,
        isDownloadedFile: args.isDownloadedFile,
      );
    },
  );
}

class AudioPlayerRouteArgs {
  const AudioPlayerRouteArgs({
    required this.file,
    this.key,
    this.isDownloadedFile,
  });

  final Folder file;

  final Key? key;

  final bool? isDownloadedFile;

  @override
  String toString() {
    return 'AudioPlayerRouteArgs{file: $file, key: $key, isDownloadedFile: $isDownloadedFile}';
  }
}

/// generated route for
/// [CalendarPage]
class CalendarRoute extends PageRouteInfo<void> {
  const CalendarRoute({List<PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CalendarPage();
    },
  );
}

/// generated route for
/// [DownloadsPage]
class DownloadsRoute extends PageRouteInfo<void> {
  const DownloadsRoute({List<PageRouteInfo>? children})
      : super(
          DownloadsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DownloadsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DownloadsPage();
    },
  );
}

/// generated route for
/// [FavoritesPage]
class FavoritesRoute extends PageRouteInfo<void> {
  const FavoritesRoute({List<PageRouteInfo>? children})
      : super(
          FavoritesRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoritesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesPage();
    },
  );
}

/// generated route for
/// [ForgetPasswordPage]
class ForgetPasswordRoute extends PageRouteInfo<void> {
  const ForgetPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgetPasswordPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LibraryPage]
class LibraryRoute extends PageRouteInfo<LibraryRouteArgs> {
  LibraryRoute({
    String? folderId,
    String? folderName,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LibraryRoute.name,
          args: LibraryRouteArgs(
            folderId: folderId,
            folderName: folderName,
            key: key,
          ),
          rawPathParams: {'folderId': folderId},
          initialChildren: children,
        );

  static const String name = 'LibraryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<LibraryRouteArgs>(
          orElse: () =>
              LibraryRouteArgs(folderId: pathParams.optString('folderId')));
      return LibraryPage(
        folderId: args.folderId,
        folderName: args.folderName,
        key: args.key,
      );
    },
  );
}

class LibraryRouteArgs {
  const LibraryRouteArgs({
    this.folderId,
    this.folderName,
    this.key,
  });

  final String? folderId;

  final String? folderName;

  final Key? key;

  @override
  String toString() {
    return 'LibraryRouteArgs{folderId: $folderId, folderName: $folderName, key: $key}';
  }
}

/// generated route for
/// [LibraryTabPage]
class LibraryTabRoute extends PageRouteInfo<void> {
  const LibraryTabRoute({List<PageRouteInfo>? children})
      : super(
          LibraryTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'LibraryTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LibraryTabPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [PdfViewerPage]
class PdfViewerRoute extends PageRouteInfo<PdfViewerRouteArgs> {
  PdfViewerRoute({
    Key? key,
    required Folder file,
    bool? isDownloadedFile,
    List<PageRouteInfo>? children,
  }) : super(
          PdfViewerRoute.name,
          args: PdfViewerRouteArgs(
            key: key,
            file: file,
            isDownloadedFile: isDownloadedFile,
          ),
          initialChildren: children,
        );

  static const String name = 'PdfViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PdfViewerRouteArgs>();
      return PdfViewerPage(
        key: args.key,
        file: args.file,
        isDownloadedFile: args.isDownloadedFile,
      );
    },
  );
}

class PdfViewerRouteArgs {
  const PdfViewerRouteArgs({
    this.key,
    required this.file,
    this.isDownloadedFile,
  });

  final Key? key;

  final Folder file;

  final bool? isDownloadedFile;

  @override
  String toString() {
    return 'PdfViewerRouteArgs{key: $key, file: $file, isDownloadedFile: $isDownloadedFile}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [ResetPasswordPage]
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    Key? key,
    required String code,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          ResetPasswordRoute.name,
          args: ResetPasswordRouteArgs(
            key: key,
            code: code,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordRouteArgs>();
      return ResetPasswordPage(
        key: args.key,
        code: args.code,
        email: args.email,
      );
    },
  );
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({
    this.key,
    required this.code,
    required this.email,
  });

  final Key? key;

  final String code;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key, code: $code, email: $email}';
  }
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TodoCounterPage]
class TodoCounterRoute extends PageRouteInfo<TodoCounterRouteArgs> {
  TodoCounterRoute({
    Key? key,
    required TodoModel todo,
    List<PageRouteInfo>? children,
  }) : super(
          TodoCounterRoute.name,
          args: TodoCounterRouteArgs(
            key: key,
            todo: todo,
          ),
          initialChildren: children,
        );

  static const String name = 'TodoCounterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TodoCounterRouteArgs>();
      return TodoCounterPage(
        key: args.key,
        todo: args.todo,
      );
    },
  );
}

class TodoCounterRouteArgs {
  const TodoCounterRouteArgs({
    this.key,
    required this.todo,
  });

  final Key? key;

  final TodoModel todo;

  @override
  String toString() {
    return 'TodoCounterRouteArgs{key: $key, todo: $todo}';
  }
}

/// generated route for
/// [TodoPage]
class TodoRoute extends PageRouteInfo<void> {
  const TodoRoute({List<PageRouteInfo>? children})
      : super(
          TodoRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TodoPage();
    },
  );
}

/// generated route for
/// [VerificationPage]
class VerificationRoute extends PageRouteInfo<VerificationRouteArgs> {
  VerificationRoute({
    Key? key,
    required String name,
    required String email,
    required String password,
    List<PageRouteInfo>? children,
  }) : super(
          VerificationRoute.name,
          args: VerificationRouteArgs(
            key: key,
            name: name,
            email: email,
            password: password,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteArgs>();
      return VerificationPage(
        key: args.key,
        name: args.name,
        email: args.email,
        password: args.password,
      );
    },
  );
}

class VerificationRouteArgs {
  const VerificationRouteArgs({
    this.key,
    required this.name,
    required this.email,
    required this.password,
  });

  final Key? key;

  final String name;

  final String email;

  final String password;

  @override
  String toString() {
    return 'VerificationRouteArgs{key: $key, name: $name, email: $email, password: $password}';
  }
}

/// generated route for
/// [VerifyForgetPasswordPage]
class VerifyForgetPasswordRoute
    extends PageRouteInfo<VerifyForgetPasswordRouteArgs> {
  VerifyForgetPasswordRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          VerifyForgetPasswordRoute.name,
          args: VerifyForgetPasswordRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyForgetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyForgetPasswordRouteArgs>();
      return VerifyForgetPasswordPage(
        key: args.key,
        email: args.email,
      );
    },
  );
}

class VerifyForgetPasswordRouteArgs {
  const VerifyForgetPasswordRouteArgs({
    this.key,
    required this.email,
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'VerifyForgetPasswordRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [VideoPlayerPage]
class VideoPlayerRoute extends PageRouteInfo<VideoPlayerRouteArgs> {
  VideoPlayerRoute({
    required Folder file,
    bool? isDownloadedFile,
    List<PageRouteInfo>? children,
  }) : super(
          VideoPlayerRoute.name,
          args: VideoPlayerRouteArgs(
            file: file,
            isDownloadedFile: isDownloadedFile,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoPlayerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VideoPlayerRouteArgs>();
      return VideoPlayerPage(
        file: args.file,
        isDownloadedFile: args.isDownloadedFile,
      );
    },
  );
}

class VideoPlayerRouteArgs {
  const VideoPlayerRouteArgs({
    required this.file,
    this.isDownloadedFile,
  });

  final Folder file;

  final bool? isDownloadedFile;

  @override
  String toString() {
    return 'VideoPlayerRouteArgs{file: $file, isDownloadedFile: $isDownloadedFile}';
  }
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomePage();
    },
  );
}
