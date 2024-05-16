import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:superfrog/app/app_view.dart';
import 'package:superfrog/app/widgets/captcha_dialog.dart';

class Captcha {
  const Captcha._();

  static Future<String?> getToken() async {
    var context = GetIt.I.get<ScaffoldMessengerKeySingleton>().key.currentState?.context;
    String? token;
    if (context != null) {
      token = await showDialog<String>(context: context, builder: (context) => const CaptchaDialog());
    }
    return token;
  }
}
