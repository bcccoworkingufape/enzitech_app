// 🐦 Flutter imports:
import 'field_validator.dart';

// 🌍 Project imports:

/// Limites de entrada centralizados e focados em segurança reutilizados nos
/// formulários críticos do app. Reutilizá-los mantém as regras consistentes e
/// evita inconsistências ocultas entre telas.
class SecurityValidators {
  SecurityValidators._();

  // Limites de tamanho
  static const int maxEmailLength = 254; // RFC 5321
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 120;
  static const int maxInstitutionLength = 200;
  static const int maxDescriptionLength = 2000;
  static const int maxShortTextLength = 250;
  static const int maxVolumeMl = 1000; // mL per well

  // Faixas numéricas
  static const double minRepetitions = 1;
  static const double maxRepetitions = 100;
  static const double minSampleAbsorbance = 0.0;
  static const double maxSampleAbsorbance = 5.0;
  static const double minDurationHours = 0.5;
  static const double maxDurationHours = 240.0;
  static const double minVariable = -1.0e6;
  static const double maxVariable = 1.0e6;
  static const double minSizeGrams = 0.001;
  static const double maxSizeGrams = 1000.0;

  static List<ValidateRule> email({int maxLength = maxEmailLength}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.email),
    ValidateRule(ValidateTypes.max, value: maxLength),
  ];

  static List<ValidateRule> password({int maxLength = maxPasswordLength}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.strongPassword),
    ValidateRule(ValidateTypes.max, value: maxLength),
  ];

  static List<ValidateRule> requiredName({int maxLength = maxNameLength}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.name),
    ValidateRule(ValidateTypes.max, value: maxLength),
  ];

  static List<ValidateRule> requiredInstitution({int maxLength = maxInstitutionLength}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.name),
    ValidateRule(ValidateTypes.max, value: maxLength),
  ];

  static List<ValidateRule> requiredShortText({int maxLength = maxShortTextLength}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.max, value: maxLength),
  ];

  static List<ValidateRule> requiredLongText({int maxLength = maxDescriptionLength}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.max, value: maxLength),
  ];

  static List<ValidateRule> repetitions() => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.number),
    ValidateRule(ValidateTypes.greaterThanZero),
    ValidateRule(ValidateTypes.min, value: minRepetitions),
    ValidateRule(ValidateTypes.max, value: maxRepetitions),
  ];

  static List<ValidateRule> absorbance({bool isInteger = false}) => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.numeric),
    ValidateRule(ValidateTypes.greaterThanZeroDecimal),
    ValidateRule(ValidateTypes.min, value: minSampleAbsorbance),
    ValidateRule(ValidateTypes.max, value: maxSampleAbsorbance),
    if (isInteger) ValidateRule(ValidateTypes.isInteger),
  ];

  static List<ValidateRule> duration() => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.numeric),
    ValidateRule(ValidateTypes.greaterThanZeroDecimal),
    ValidateRule(ValidateTypes.isInteger),
    ValidateRule(ValidateTypes.min, value: minDurationHours),
    ValidateRule(ValidateTypes.max, value: maxDurationHours),
  ];

  static List<ValidateRule> variableA() => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.numeric),
    ValidateRule(ValidateTypes.greaterThanZeroDecimal),
    ValidateRule(ValidateTypes.min, value: minVariable),
    ValidateRule(ValidateTypes.max, value: maxVariable),
  ];

  static List<ValidateRule> sampleSize() => [
    ValidateRule(ValidateTypes.required),
    ValidateRule(ValidateTypes.numeric),
    ValidateRule(ValidateTypes.greaterThanZeroDecimal),
    ValidateRule(ValidateTypes.min, value: minSizeGrams),
    ValidateRule(ValidateTypes.max, value: maxSizeGrams),
  ];
}
