// 🐦 Flutter imports:
import 'package:enzitech_app/src/shared/input_formatters.dart/input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
}
