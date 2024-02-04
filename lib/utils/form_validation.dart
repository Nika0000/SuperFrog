import 'package:superfrog/utils/extensions.dart';

class FormValidation {
  FormValidation._();

  static String? email(String? email) {
    RegExp regExp = RegExp(
        r'^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)');
    if (email.isNullOrEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(email!)) {
      return "Please enter valid email.";
    }
    return null;
  }

  static String? password(String? password) {
    RegExp regex = RegExp(r'^.*(?=.*\d)(?=.*\d)[a-zA-Z0-9!@#$%.]+$');
    if (password.isNullOrEmpty) {
      return 'Password is required';
    } else if (password!.length < 6) {
      return 'Password must be at last 6 characters long.';
    } else if (!regex.hasMatch(password)) {
      return 'Password must contain at last one digit.';
    }
    return null;
  }
}
