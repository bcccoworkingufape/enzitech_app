// 🎯 Dart imports:
import 'dart:async';
import 'dart:ui';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../validator/validator.dart';

typedef WhenCondition = bool Function();

class Toolkit {
  static String doubleToPercentual(double value) {
    return '${(value * 100).round()}%';
  }

  static String formatDocumentType(String document) {
    document = removeEspecialCharacters(document);

    if (document.length > 11) {
      return 'CNPJ - ${CNPJValidator.format(document)}';
    }

    return 'CPF - ${CPFValidator.format(document)}';
  }

  static String removeEspecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  static String sanitizePhoneNumber(String phone) {
    return phone.replaceAll(RegExp('[^0-9]'), '');
  }

  static String capitalizeFirst(String text) {
    return "${text[0].toUpperCase()}${text.substring(1)}";
  }

  static String capitalizeAll(String text) {
    return text.split(" ").map(capitalizeFirst).toList().join(" ");
  }

  static String formatBrDate(DateTime date) {
    var format = DateFormat("dd 'de' MMMM 'de' yyyy", "pt_BR");
    return format.format(date);
  }

  static String formatBrDateTime(DateTime date) {
    var format = DateFormat("dd 'de' MMMM 'de' yyyy, HH:mm", "pt_BR");
    return format.format(date);
  }

  static String formatBrDateNumbersOnly(DateTime date) {
    var format = DateFormat("dd/MM/yyyy", "pt_BR");
    return format.format(date);
  }

  static String formatBrDateTimeNumbersOnly(DateTime date) {
    var format = DateFormat("dd/MM/yyyy, HH:mm", "pt_BR");
    return format.format(date);
  }

  static String formatBrMoney(double value) {
    return NumberFormat.currency(
      locale: 'pt-BR',
      decimalDigits: 2,
      symbol: 'R\$',
    ).format(value);
  }

  static String getObjValue(dynamic obj, int propIndex, List propArr) {
    var prop = propArr[propIndex];
    if (propIndex == propArr.length - 1) {
      return obj[prop].toString().toLowerCase();
    } else {
      return getObjValue(obj[prop], propIndex + 1, propArr);
    }
  }

  static List<T> orderList<T>(String order, String fieldOrder, List<T> list) {
    var propArr = fieldOrder.split(".");
    return list
      ..sort((a, b) {
        var mapA = (a as dynamic).toMap();
        var mapB = (b as dynamic).toMap();
        var valueA = getObjValue(mapA, 0, propArr);
        var valueB = getObjValue(mapB, 0, propArr);
        if (order == "asc") {
          return valueA.compareTo(valueB);
        } else {
          return valueB.compareTo(valueA);
        }
      });
  }

  static Future<void> when(
      WhenCondition condition, VoidCallback executor, int milliseconds) async {
    var limitSum = 0;
    Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      if (condition()) {
        executor();
        timer.cancel();
      } else if (limitSum > 500) {
        timer.cancel();
      }
      limitSum++;
    });
  }

  static dynamic encodeDateTime(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
