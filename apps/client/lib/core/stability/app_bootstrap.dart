import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Global crash guards + performance hooks applied at startup.
abstract final class AppBootstrap {
  static void initialize() {
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
  }
}
