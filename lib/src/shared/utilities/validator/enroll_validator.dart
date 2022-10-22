class EnrollValidator {
  static bool isValid(String value) {
    var result = num.tryParse(value);
    return result != null;
  }
}
