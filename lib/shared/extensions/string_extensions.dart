// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime get dateFromTimestampString {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(this);
  }

  DateTime get dateFromddMMyyyy {
    return DateFormat('dd/MM/yyyy').parse(this);
  }

  String capitalizeFirstLetter() {
    if (this != '') {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }

    return '';
  }

  /// This function will convert a valid input to a list
  /// In case the input is invalid, it will print out a message
  List? get convertStringToList {
    List output;
    try {
      output = json.decode(this);
      return output;
    } catch (e) {
      if (kDebugMode) {
        print(
            'Error in convertStringToList: The input is not a string representation of a list');
      }
      return null;
    }
  }
}
