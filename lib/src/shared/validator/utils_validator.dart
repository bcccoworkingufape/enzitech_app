// 🌎 Project imports:
import '../util/toolkit.dart';
import 'cnpj_validator.dart';
import 'cpf_validator.dart';

class Validator {
  static bool email(String email) {
    return RegExp(
                r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email) &&
        !blockEmoji().hasMatch(email);
  }

  static bool isValidCPF(String document) =>
      document.isEmpty || document.trim().length < 11
          ? true
          : CPFValidator.isValid(document);

  static bool isValidCNPJ(String document) =>
      document.isEmpty || document.trim().length < 14
          ? true
          : CNPJValidator.isValid(document);

  static bool isStrongPassword(String password) =>
      password.length >= 8 &&
      containSpetialChars(password) &&
      containUppercaseLetter(password) &&
      containLowercaseLetter(password);

  static bool isAlfanumeric(String text) {
    return RegExp(r"^[a-zA-Z0-9À-ÖØ-öø-ÿ&\- ]*$").hasMatch(text);
  }

  static bool isName(String text) {
    return RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ&\- ]*$").hasMatch(text);
  }

  static bool containSpetialChars(String text) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
  }

  static bool containUppercaseLetter(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  static bool containLowercaseLetter(String text) {
    return RegExp(r'[a-z]').hasMatch(text);
  }

  static bool containNumber(String text) {
    return !RegExp(r'[A-Z]').hasMatch(text);
  }

  static bool isHTML(String text) {
    return RegExp(
            r'<!DOCTYPE html>|</?\s*[a-z-][^>]*\s*>|(\&(?:[\w\d]+|#\d+|#x[a-f\d]+);)')
        .hasMatch(text);
  }

  static bool isPhone(String text) {
    var phone = Toolkit.removeEspecialCharacters(text);
    return phone.length == 11 || phone.length == 10;
  }

  static bool isCellPhone(String text) {
    var phone = Toolkit.removeEspecialCharacters(text);

    return phone.length == 13;
  }

  static RegExp blockEmoji() {
    return RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  }
}
