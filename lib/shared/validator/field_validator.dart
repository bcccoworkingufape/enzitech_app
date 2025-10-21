// 🐦 Flutter imports:
import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';

// 🌎 Project imports:
import '../utils/utils.dart';
import 'validator.dart';

enum ValidateTypes {
  required,
  alfanumeric,
  cellphone,
  cnpj,
  cpf,
  cpfOrCnpj,
  creditCardDueDate,
  creditCardNumber,
  creditCardSecurityCode,
  email,
  emailEquals,
  emailOrRegistration,
  greaterThanZero,
  greaterThanZeroDecimal,
  isInteger,
  max,
  maxAge,
  min,
  minAge,
  name,
  notFound,
  number,
  numeric,
  passwordEquals,
  passwordMustBeDiff,
  phone,
  strongPassword,
}

class ValidateRule {
  final ValidateTypes validateTypes;
  final dynamic value;
  final String? customErrorMessage;

  ValidateRule(this.validateTypes, {this.value, this.customErrorMessage});
}

class FieldValidator {
  final List<ValidateRule> validations;
  final BuildContext context;

  FieldValidator(this.validations, this.context);

  String? validate(dynamic value, {String? confirmation}) {
    final l10n = AppLocalizations.of(context)!;
    String? result;

    for (var i = 0; i < validations.length; i++) {
      var validateRule = validations.elementAt(i);

      var key = validateRule.validateTypes;
      var valueRule = validateRule.value;
      var customErrorMessage = validateRule.customErrorMessage;

      switch (key) {
        case ValidateTypes.required:
          {
            if (value == null || value.toString().trim().isEmpty) {
              result = customErrorMessage ?? l10n.validation_required;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.strongPassword:
          {
            var isStrong = Validator.isStrongPassword(value);
            if (!isStrong) {
              result = customErrorMessage ?? l10n.validation_strongPassword;
            } else {
              result = null;
            }
            break;
          }

        case ValidateTypes.alfanumeric:
          {
            var isStrong = Validator.isAlfanumeric(value);
            if (!isStrong) {
              result = customErrorMessage ?? l10n.validation_alfanumeric;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.name:
          {
            var isStrong = Validator.isName(value);
            if (!isStrong) {
              result = customErrorMessage ?? l10n.validation_name;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.phone:
          {
            if (value == null || value.toString().trim().isEmpty) {
              result = null;
              break;
            }

            var isStrong = Validator.isPhone(value);
            if (!isStrong) {
              result = customErrorMessage ?? l10n.validation_phone;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cellphone:
          {
            if (value == null || value.toString().trim().isEmpty) {
              result = null;
              break;
            }

            var isStrong = Validator.isCellPhone(value);
            if (!isStrong) {
              result = customErrorMessage ?? l10n.validation_cellphone;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.passwordEquals:
          {
            var pass = value.toString();
            var confirm = confirmation;

            var isStrong = pass == confirm;
            if (!isStrong) {
              result =
                  customErrorMessage ?? l10n.validation_passwordEquals;
            } else {
              result = null;
            }
            break;
          }

        case ValidateTypes.passwordMustBeDiff:
          {
            var pass = value.toString();
            var confirm = confirmation;

            var isDiff = pass != confirm;
            if (!isDiff) {
              result = customErrorMessage ?? l10n.validation_passwordMustBeDiff;
            } else {
              result = null;
            }
            break;
          }

        case ValidateTypes.notFound:
          result = l10n.validation_notFound;
          break;

        case ValidateTypes.emailEquals:
          {
            var pass = value.toString();
            var confirm = confirmation;

            var isStrong = pass == confirm;
            if (!isStrong) {
              result = customErrorMessage ?? l10n.validation_emailEquals;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.email:
          {
            var emailValid = Validator.email(value.toString());
            if (!emailValid) {
              result = customErrorMessage ?? l10n.validation_email;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cpf:
          {
            if (!CPFValidator.isValid(value.toString())) {
              result = customErrorMessage ?? l10n.validation_cpf;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cnpj:
          {
            if (!CNPJValidator.isValid(value.toString())) {
              result = customErrorMessage ?? l10n.validation_cnpj;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cpfOrCnpj:
          {
            var text = Toolkit.removeEspecialCharacters(value.toString());
            if (text.length <= 11) {
              if (!CPFValidator.isValid(value.toString())) {
                result = customErrorMessage ?? l10n.validation_cpf;
              } else {
                result = null;
              }
            } else {
              if (!CNPJValidator.isValid(value.toString())) {
                result = customErrorMessage ?? l10n.validation_cnpj;
              } else {
                result = null;
              }
            }
            break;
          }

        case ValidateTypes.numeric:
          {
            if (value == null) {
              result = customErrorMessage ?? l10n.validation_numeric;
            }

            if (double.tryParse(value) != null) {
              result = null;
            }
            break;
          }

        case ValidateTypes.number:
          {
            var isNumber = Validator.isNumeric(value);
            if (!isNumber) {
              result = customErrorMessage ?? l10n.validation_number;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.greaterThanZeroDecimal:
          {
            var number = double.parse(value);
            if (number <= 0) {
              result =
                  customErrorMessage ?? l10n.validation_greaterThanZeroDecimal;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.isInteger:
          {
            var number = int.tryParse(value);

            if (number is int) {
              result = null;
            } else {
              result = customErrorMessage ?? l10n.validation_isInteger;
            }
            break;
          }
        case ValidateTypes.greaterThanZero:
          {
            var number = int.parse(value);
            if (number < 1) {
              result =
                  customErrorMessage ?? l10n.validation_greaterThanZero;
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.max:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value > valueRule) {
                result = customErrorMessage ?? l10n.validation_maxNumber(valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length > valueRule) {
                result = customErrorMessage ?? l10n.validation_maxChars(valueRule.toString());
              } else {
                result = null;
              }
            }
            break;
          }
        case ValidateTypes.maxAge:
          {
            var val = int.parse(value);

            if (val > valueRule) {
              result = customErrorMessage ?? l10n.validation_maxAge(valueRule.toString());
            } else {
              result = null;
            }

            break;
          }
        case ValidateTypes.minAge:
          {
            var val = int.parse(value);
            if (valueRule > val) {
              result = customErrorMessage ?? l10n.validation_minAge(valueRule.toString());
            } else {
              result = null;
            }

            break;
          }
        case ValidateTypes.min:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value < valueRule) {
                result = customErrorMessage ?? l10n.validation_minNumber(valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length < valueRule) {
                result = customErrorMessage ?? l10n.validation_minChars(valueRule.toString());
              } else {
                result = null;
              }
            }
            break;
          }
        case ValidateTypes.emailOrRegistration:
          {
            if (!value.toString().contains('@')) {
              if (!EnrollValidator.isValid(value.toString()) &&
                  !CNPJValidator.isValid(value.toString()) &&
                  !CPFValidator.isValid(value.toString())) {
                result =
                    customErrorMessage ?? l10n.validation_emailOrRegistration;
              } else {
                result = null;
              }
            } else {
              var emailValid = Validator.email(value.toString());
              if (!emailValid) {
                result =
                    customErrorMessage ?? l10n.validation_emailOrRegistration;
              } else {
                result = null;
              }
            }
            break;
          }
        default:
          {
            result = null;
            break;
          }
      }
      if (result != null && result != "") {
        break;
      }
    }

    return result;
  }
}
