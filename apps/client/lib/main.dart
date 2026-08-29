import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/stability/app_bootstrap.dart';
import 'app.dart';

Future<void> main() async {
  await AppBootstrap.initialize();
  runApp(
    const ProviderScope(
      child: MindTouchApp(),
    ),
  );
}
