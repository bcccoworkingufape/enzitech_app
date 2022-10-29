// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/utilities/input_formatters/input_formatters.dart';

class Constants {
  static const padding16all = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 16.0,
  );

  static const bccCoworkingLink = 'http://app.uag.ufrpe.br/bcccoworking/home';

  static const betaGlucosidase = 'Betaglucosidase';
  static const aryl = 'Aryl';
  static const fosfataseAcida = 'FosfataseAcida';
  static const fosfataseAlcalina = 'FosfataseAlcalina';

  static final enzymeDecimalInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\,?\d{0,5}')),
    CommaTextInputFormatter(),
  ];

  static const List<String> typesOfEnzymesList = <String>[
    'Betaglucosidase',
    'Aryl',
    'FosfataseAcida',
    'FosfataseAlcalina',
    'Urease'
  ];

  static const List<String> typesOfEnzymesListFormmated = <String>[
    'Beta-glucosidase',
    'Aryl',
    'Fosfatase Ácida',
    'Fosfatase Alcalina',
    'Urease',
  ];

  static Color dealWithEnzymeChipColor(String type) {
    if (type == Constants.typesOfEnzymesList[0]) {
      return AppColors.betaGlucosidase;
    } else if (type == Constants.typesOfEnzymesList[1]) {
      return AppColors.aryl;
    } else if (type == Constants.typesOfEnzymesList[2]) {
      return AppColors.fosfataseAcida;
    } else if (type == Constants.typesOfEnzymesList[3]) {
      return AppColors.fosfataseAlcalina;
    } else if (type == Constants.typesOfEnzymesList[4]) {
      return AppColors.urease;
    } else {
      return Colors.black;
    }
  }
}
