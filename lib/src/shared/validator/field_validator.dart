// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/validator/cnpj_validator.dart';
import 'package:enzitech_app/src/shared/validator/cpf_validator.dart';
import 'package:enzitech_app/src/shared/validator/enroll_validator.dart';
import 'package:enzitech_app/src/shared/validator/utils_validator.dart';

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
  numeric,
  greaterThanZero,
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
              result = customErrorMessage ??
                  "⚠  Campo não aceita caracteres especiais";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.name:
          {
            var isStrong = Validator.isName(value);
            if (!isStrong) {
              result = customErrorMessage ?? "⚠  Nome inválido";
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
              result = customErrorMessage ?? "⚠ Número inválido";
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
              result = customErrorMessage ?? "⚠ Número inválido";
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
                  customErrorMessage ?? "⚠  As senhas digitadas não coincidem.";
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
              result = customErrorMessage ??
                  "⚠  A nova senha não pode ser igual a senha atual.";
            } else {
              result = null;
            }
            break;
          }

        case ValidateTypes.notFound:
          result = "⚠  Não encontrado";
          break;

        case ValidateTypes.emailEquals:
          {
            var pass = value.toString();
            var confirm = confirmation;

            var isStrong = pass == confirm;
            if (!isStrong) {
              result = customErrorMessage ??
                  "⚠  Os e-mails digitados não coincidem.";
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
              result = customErrorMessage ?? "⚠  CPF inválido";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.cnpj:
          {
            if (!CNPJValidator.isValid(value.toString())) {
              result = customErrorMessage ?? "⚠  CNPJ inválido";
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
                result = customErrorMessage ?? "⚠  CPF inválido";
              } else {
                result = null;
              }
            } else {
              if (!CNPJValidator.isValid(value.toString())) {
                result = customErrorMessage ?? "⚠  CNPJ inválido";
              } else {
                result = null;
              }
            }
            break;
          }

        case ValidateTypes.numeric:
          {
            if (value == null) {
              result = customErrorMessage ?? "⚠  Número inválido";
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
              result = customErrorMessage ?? "⚠  Número inválido";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.greaterThanZero:
          {
            var number = int.parse(value);
            if (number < 1) {
              result =
                  customErrorMessage ?? "⚠  Insira um número maior que zero";
            } else {
              result = null;
            }
            break;
          }
        case ValidateTypes.max:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value > valueRule) {
                result = customErrorMessage ??
                    "⚠  Número deve ser menor ou igual a {{p1}}."
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length > valueRule) {
                result = customErrorMessage ??
                    "⚠  Esse campo deve ter no máximo {{p1}} caractere(s)"
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else {
              result = customErrorMessage ??
                  "⚠  Esse campo deve ter no máximo {{p1}} caractere(s)"
                      .replaceAll("{{p1}}", valueRule.toString());
            }
            break;
          }
        case ValidateTypes.maxAge:
          {
            var val = int.parse(value);

            if (val > valueRule) {
              result = customErrorMessage ??
                  "⚠  Idade máxima {{p1}} anos"
                      .replaceAll("{{p1}}", valueRule.toString());
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
                  "⚠  Idade mínima {{p1}} anos"
                      .replaceAll("{{p1}}", valueRule.toString());
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
                    "⚠  Número deve ser maior ou igual a {{p1}}."
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length < valueRule) {
                result = customErrorMessage ??
                    "⚠  Esse campo deve ter no mínimo {{p1}} caractere(s)"
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else {
              result = customErrorMessage ??
                  "⚠  Esse campo deve ter no mínimo {{p1}} caractere(s)"
                      .replaceAll("{{p1}}", valueRule.toString());
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
                    customErrorMessage ?? "⚠ E-mail ou matrícula inválido.";
              } else {
                result = null;
              }
            } else {
              var emailValid = Validator.email(value.toString());
              if (!emailValid) {
                result =
                    customErrorMessage ?? "⚠ E-mail ou matrícula inválido.";
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
