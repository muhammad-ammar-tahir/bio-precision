import 'package:flutter/foundation.dart';

/// Lightweight logger that is silenced in release builds.
class AppLogger {
  const AppLogger._();

  static void d(String message, {String tag = 'BioPrecision'}) {
    if (kDebugMode) debugPrint('[$tag] DEBUG: $message');
  }

  static void i(String message, {String tag = 'BioPrecision'}) {
    if (kDebugMode) debugPrint('[$tag] INFO: $message');
  }

  static void w(String message, {String tag = 'BioPrecision'}) {
    if (kDebugMode) debugPrint('[$tag] WARN: $message');
  }

  static void e(String message, {Object? error, StackTrace? stack, String tag = 'BioPrecision'}) {
    if (kDebugMode) {
      debugPrint('[$tag] ERROR: $message');
      if (error != null) debugPrint('  └─ $error');
      if (stack != null) debugPrint('  └─ $stack');
    }
  }
}
