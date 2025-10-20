
import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message) {
    // Filter out noisy system messages
    if (!message.contains('ApkAssets') &&
        !message.contains('TalkBack') &&
        !message.contains('empty')) {
      if (kDebugMode) {
        print('APP: $message');
      }
    }
  }

  static void error(String message, [dynamic error]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) {
        print('ERROR DETAILS: $error');
      }
    }
  }
}