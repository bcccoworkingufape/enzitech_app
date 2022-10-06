// 🐦 Flutter imports:
import 'package:flutter/services.dart';

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String truncated = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newValue.text.contains(",")) {
      truncated = newValue.text.replaceFirst(RegExp(','), '.');
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}
