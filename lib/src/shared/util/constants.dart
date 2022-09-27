// 🐦 Flutter imports:
import 'package:flutter/material.dart';

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

  static const List<String> typesOfEnzymesList = <String>[
    'Betaglucosidase',
    'Aryl',
    'FosfataseAcida',
    'FosfataseAlcalina',
  ];

  static const List<String> typesOfEnzymesListFormmated = <String>[
    'Beta-glucosidase',
    'Aryl',
    'Fosfatase Ácida',
    'Fosfatase Alcalina',
  ];
}
