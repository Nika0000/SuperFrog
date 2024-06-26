import 'package:easy_localization/easy_localization.dart';
import 'package:superfrog/utils/extensions.dart';

class FormValidation {
  FormValidation._();

  static String? email(String? email) {
    RegExp regExp = RegExp(
        r'^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)');
    if (email.isNullOrEmpty) {
      return 'auth.errors.email_required'.tr();
    } else if (!regExp.hasMatch(email!)) {
      return 'auth.errors.email_invalid_format'.tr();
    }
    return null;
  }

  static String? password(String? password) {
    RegExp regex = RegExp(r'^.*(?=.*\d)(?=.*\d)[a-zA-Z0-9!@#$%.]+$');
    if (password.isNullOrEmpty) {
      return 'auth.errors.password_required'.tr();
    } else if (password!.length < 6) {
      return 'auth.errors.password_invalid_lenght'.tr();
    } else if (!regex.hasMatch(password)) {
      return 'auth.errors.password_invalid_format'.tr();
    }
    return null;
  }
}
