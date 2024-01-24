// ignore_for_file: non_constant_identifier_names

// 📦 Package imports:
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  /// Returns String in
  /// this format. Ex: 07 de Outubro de 2021 às 12:32:35
  String get ddMMyyHHmmss {
    final dateFormatDate = DateFormat('dd/MM/yy');
    final dateFormatTime = DateFormat('HH:mm:ss');

    final date = dateFormatDate.format(this);
    final time = dateFormatTime.format(this);

    return '$date às $time';
  }

  /// Returns String in
  /// this format. Ex: 07/10/2021
  String get ddMMyyyy {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return dateFormat.format(this);
  }

  /// Returns String in
  /// this format. Ex: Terça-feira, 07 de Outubro de 2021
  String get EEEEddMMMMyyyy {
    var dateFormat = DateFormat("EEEE, dd 'de' MMMM 'de' yyyy");

    return dateFormat.format(this);
  }

  /// Returns String in
  /// this format. Ex: Ter, 07 Outubro 2021
  String get EddMMMMyyyy {
    var dateFormat = DateFormat("E, dd MMMM yyyy", "pt_BR");

    var dateResult = dateFormat.format(this);
    return '${dateResult.substring(0, 1).toUpperCase()}${dateResult.substring(1)}';
  }

  /// Returns String in
  /// this format: Ex: 09 Ago
  String get ddMMM {
    var dateFormat = DateFormat("dd MMMM");

    return dateFormat.format(this).substring(0, 6);
  }

  /// Returns String in
  /// this format: 13:45
  String get HHmm {
    var dateFormat = DateFormat("HH:mm");

    return dateFormat.format(this);
  }
}
