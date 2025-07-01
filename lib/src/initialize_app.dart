import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:path_provider/path_provider.dart';

import 'core/utils/firebase_notifications.dart';
import 'core/utils/global_config.dart';
import 'features/library/data/models/folder.dart';
import 'features/library/data/models/media_file.dart';
import 'injection_container.dart';

enum Environment {
  dev,
  stage,
  prod,
}

class InitializeApp {
  factory InitializeApp() {
    return _initializeApp;
  }

  InitializeApp._internal();

  static final InitializeApp _initializeApp = InitializeApp._internal();

  Future<void> initApp(Environment env) async {
    WidgetsFlutterBinding.ensureInitialized();

    /// injection dependency
    setupLocator();

    /// translation
    await EasyLocalization.ensureInitialized();

    /// audio
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.kabdev.storagebud.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );

    /// downloads
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(MediaFileAdapter());
    Hive.registerAdapter(FolderAdapter());
    await Hive.openBox<Folder>('downloads');

    /// firebase
    await FirebaseNotifications().initFirebase();

    /// load our config
    await GlobalConfig.forEnvironment(env);

    final _noScreenshot = NoScreenshot.instance;
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
