import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length <= 3) {
      return newValue.copyWith(
        text: newText,
        selection: updateCursorPosition(newText.length),
      );
    } else if (newText.length <= 6) {
      return newValue.copyWith(
        text: '${newText.substring(0, 3)}-${newText.substring(3)}',
        selection: updateCursorPosition(newText.length + 1),
      );
    } else if (newText.length <= 10) {
      return newValue.copyWith(
        text:
            '${newText.substring(0, 3)}-${newText.substring(3, 7)}-${newText.substring(7)}',
        selection: updateCursorPosition(newText.length + 2),
      );
    } else if (newText.length > 10) {
      return newValue.copyWith(
        text:
            '${newText.substring(0, 2)}-${newText.substring(2, 6)}-${newText.substring(6, 10)}',
        selection: updateCursorPosition(newText.length + 2),
      );
    }
    return newValue;
  }

  TextSelection updateCursorPosition(int length) {
    return TextSelection.fromPosition(TextPosition(offset: length));
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length > newValue.text.length) {
      // Backspace detected. Return without format
      return newValue;
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length <= 2) {
      return newValue.copyWith(
        text: newText.length == 2 ? '$newText:' : newText,
        selection: updateCursorPosition(
            newText.length + (newText.length == 2 ? 1 : 0)),
      );
    } else if (newText.length <= 4) {
      return newValue.copyWith(
        text:
            '${newText.substring(0, 2)}:${newText.substring(2)}${newText.length == 4 ? ' - ' : ''}',
        selection: updateCursorPosition(
            newText.length + 1 + (newText.length == 4 ? 3 : 0)),
      );
    } else if (newText.length <= 6) {
      return newValue.copyWith(
        text:
            '${newText.substring(0, 2)}:${newText.substring(2, 4)} - ${newText.substring(4)}${newText.length == 6 ? ':' : ''}',
        selection: updateCursorPosition(newText.length + 4),
      );
    } else if (newText.length > 6) {
      return newValue.copyWith(
        text:
            '${newText.substring(0, 2)}:${newText.substring(2, 4)} - ${newText.substring(4, 6)}:${newText.substring(6)}',
        selection: updateCursorPosition(newText.length + 5),
      );
    }
    return newValue;
  }

  TextSelection updateCursorPosition(int length) {
    return TextSelection.fromPosition(TextPosition(offset: length));
  }
}
