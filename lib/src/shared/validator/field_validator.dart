// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/validator/enroll_validator.dart';
import 'cnpj_validator.dart';
import 'cpf_validator.dart';
import 'utils_validator.dart';

enum ValidateTypes {
  required,
  email,
  min,
  max,
  strongPassword,
  passwordEquals,
  passwordMustBeDiff,
  emailEquals,
  cpf,
  cnpj,
  cpfOrCnpj,
  number,
  alfanumeric,
  maxAge,
  minAge,
  name,
  phone,
  cellphone,
  emailOrRegistration,
  creditCardNumber,
  creditCardDueDate,
  creditCardSecurityCode,
  notFound,
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
              result = customErrorMessage ?? "⚠  Campo obrigatório";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.strongPassword:
          {
            var isStrong = Validator.isStrongPassword(value);
            if (!isStrong) {
              result = customErrorMessage ??
                  "⚠  Senha não atende ao padrão informado.";
            } else {
              result = null;
            }
            break;
          }

        case ValidateTypes.alfanumeric:
          {
            var isStrong = Validator.isAlfanumeric(value);
            if (!isStrong) {
              result = customErrorMessage ?? "TODO: MUDAR";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.name:
          {
            var isStrong = Validator.isName(value);
            if (!isStrong) {
              result = customErrorMessage ?? "TODO: MUDAR";
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
              result = customErrorMessage ?? "TODO: MUDAR";
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
              result = customErrorMessage ?? "TODO: MUDAR";
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
              result = customErrorMessage ?? "TODO: MUDAR";
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
              result = customErrorMessage ?? "TODO: MUDAR";
            } else {
              result = null;
            }
            break;
          }

        case ValidateTypes.notFound:
          result = "TODO: MUDAR";
          break;

        case ValidateTypes.emailEquals:
          {
            var pass = value.toString();
            var confirm = confirmation;

            var isStrong = pass == confirm;
            if (!isStrong) {
              result = customErrorMessage ?? "TODO: MUDAR";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.email:
          {
            var emailValid = Validator.email(value.toString());
            if (!emailValid) {
              result = customErrorMessage ?? "⚠  E-mail inválido";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cpf:
          {
            if (!CPFValidator.isValid(value.toString())) {
              result = customErrorMessage ?? "Insira um CPF válido";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cnpj:
          {
            if (!CNPJValidator.isValid(value.toString())) {
              result = customErrorMessage ?? "TODO: MUDAR";
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
                result = customErrorMessage ?? "TODO: MUDAR";
              } else {
                result = null;
              }
            } else {
              if (!CNPJValidator.isValid(value.toString())) {
                result = customErrorMessage ?? "TODO: MUDAR";
              } else {
                result = null;
              }
            }
            break;
          }
        case ValidateTypes.max:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value > valueRule) {
                result = customErrorMessage ??
                    "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length > valueRule) {
                result = customErrorMessage ??
                    "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else {
              result = customErrorMessage ??
                  "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
            }
            break;
          }
        case ValidateTypes.maxAge:
          {
            var val = int.parse(value);

            if (val > valueRule) {
              result = customErrorMessage ??
                  "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
            } else {
              result = null;
            }

            break;
          }
        case ValidateTypes.minAge:
          {
            var val = int.parse(value);
            if (valueRule > val) {
              result = customErrorMessage ??
                  "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
            } else {
              result = null;
            }

            break;
          }
        case ValidateTypes.min:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value < valueRule) {
                result = customErrorMessage ??
                    "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length < valueRule) {
                result = customErrorMessage ??
                    "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else {
              result = customErrorMessage ??
                  "TODO: MUDAR".replaceAll("{{p1}}", valueRule.toString());
            }
            break;
          }
        case ValidateTypes.emailOrRegistration:
          {
            if (!value.toString().contains('@')) {
              if (!EnrollValidator.isValid(value.toString()) &&
                  !CNPJValidator.isValid(value.toString()) &&
                  !CPFValidator.isValid(value.toString())) {
                result = customErrorMessage ?? "TODO: MUDAR";
              } else {
                result = null;
              }
            } else {
              var emailValid = Validator.email(value.toString());
              if (!emailValid) {
                result = customErrorMessage ?? "TODO: MUDAR";
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
