import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:superfrog/app/widgets/captcha_dialog.dart';
import 'package:superfrog/utils/navigation_key.dart';

class Captcha {
  static String? _token;

  static FutureOr<String?> get token async {
    String? res = _token ?? await getToken();
    _token = null;
    return res;
  }

  static set newToken(token) => _token = token;

  static Future<String?> getToken() async {
    var context = GetIt.I.get<NavigationKeySingleton>().key.currentState?.context;
    String? token;
    if (context != null) {
      token = await showDialog<String>(context: context, builder: (context) => const CaptchaDialog());
    }
    return token;
  }
}
