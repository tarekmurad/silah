import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/core/utils/l10n.dart';
import 'src/initialize_app.dart';

Future<void> main() async {
  await InitializeApp().initApp(Environment.stage);

  runApp(
    EasyLocalization(
      supportedLocales: L10n.all,
      path: 'assets/l10n',
      startLocale: L10n.all[0],
      fallbackLocale: L10n.all[0],
      child: const App(),
    ),
  );
}
