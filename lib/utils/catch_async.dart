import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> catchAsync(
  Function function, {
  required Function(String error) onError,
}) async {
  try {
    await function();
  } catch (error) {
    if (error is PlatformException) {
      debugPrint(
        '[PlatformException] -\ncode: ${error.code}\n message: ${error.message}\nDetails: ${error.details}',
      );
      onError(error.message ?? '');
    } else if (error is HttpException) {
      debugPrint('[HttpException] - message: ${error.message}\nUrl: ${error.uri}');
      onError(error.message);
    } else if (error is AuthException) {
      debugPrint('[AuthException] - message: ${error.message}');
      onError(error.message);
    } else {
      debugPrint(error.toString());
      onError(error.toString());
    }
  }
}
