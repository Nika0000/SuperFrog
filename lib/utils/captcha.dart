import 'dart:async';

import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:superfrog/app/widgets/captcha_dialog.dart';
import 'package:superfrog/utils/navigation_key.dart';

class Captcha {
  static String? _token;
  static Captcha? _instance;
  static final TurnstileController _controller = TurnstileController();

  factory Captcha() {
    _instance ??= Captcha();
    return _instance!;
  }

  static FutureOr<String?> get token async {
    String? res = _token ?? await getToken();

    _token = null;
    await _controller.refreshToken().catchError((_) {
      // TODO:executes when controller is not assigned to the CloudFlareTurnstile widget
    });
    return res;
  }

  static set newToken(token) => _token = token;

  static TurnstileController get controller => _controller;

  static set refreshToken(token) => _controller.refreshToken();

  static Future<String?> getToken() async {
    var context = GetIt.I.get<NavigationKeySingleton>().key.currentState?.context;
    String? token;
    if (context != null) {
      token = await showDialog<String>(context: context, builder: (context) => const CaptchaDialog());
    }
    return token;
  }
}
