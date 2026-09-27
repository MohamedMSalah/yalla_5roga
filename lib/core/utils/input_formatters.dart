import 'package:flutter/services.dart';

class InputFormatters {
  const InputFormatters._();

  static final TextInputFormatter noSpaces = FilteringTextInputFormatter.deny(
    RegExp(r'\s'),
  );

  static final TextInputFormatter email = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._\-]'),
  );

  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter maxLength(int length) {
    return LengthLimitingTextInputFormatter(length);
  }
}
