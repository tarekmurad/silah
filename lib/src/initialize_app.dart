import 'package:audio_service/audio_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'core/utils/global_config.dart';
import 'features/library/data/models/folder.dart';
import 'features/library/data/models/media_file.dart';
import 'injection_container.dart';

enum Environment {
  dev,
  stage,
  prod,
}

late final AudioHandler _audioHandler;

class InitializeApp {
  factory InitializeApp() {
    return _initializeApp;
  }

  InitializeApp._internal();

  static final InitializeApp _initializeApp = InitializeApp._internal();

  Future<void> initApp(Environment env) async {
    WidgetsFlutterBinding.ensureInitialized();

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.example.sila.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );

    // _audioHandler = await AudioService.init(
    //   builder: () => CustomAudioHandler(),
    //   config: const AudioServiceConfig(
    //     androidNotificationChannelId: 'com.example.sila.channel.audio',
    //     androidNotificationChannelName: 'Music playback',
    //     androidNotificationOngoing: true,
    //   ),
    // );

    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(MediaFileAdapter());
    Hive.registerAdapter(FolderAdapter());
    await Hive.openBox<Folder>('downloads');

    await EasyLocalization.ensureInitialized();

    /// Initialize injection container
    setupLocator();

    // await FirebaseNotifications().initFirebase();

    ///
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 150;

    /// load our config
    await GlobalConfig.forEnvironment(env);
  }
}
