import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlatformUtils {
  static bool get isMobile {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isAndroid || Platform.isIOS;
    }
  }

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isLinux || Platform.isFuchsia || Platform.isWindows || Platform.isMacOS;
    }
  }

  static Future<String> get appScheme async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return kIsWeb ? 'http://' : '${packageInfo.packageName}://';
  }
}
