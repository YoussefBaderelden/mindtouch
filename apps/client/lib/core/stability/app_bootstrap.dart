import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/api_endpoint.dart';

/// Global crash guards + performance hooks applied at startup.
abstract final class AppBootstrap {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kDebugMode) {
        debugPrint('[MindTouch crash] ${details.exceptionAsString()}');
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('[MindTouch async] $error\n$stack');
      }
      return true;
    };

    await ApiEndpoint.initialize();
    if (kDebugMode) {
      debugPrint('[MindTouch] API → ${ApiEndpoint.base} (cloud=${ApiEndpoint.isCloud})');
    }
  }
}
