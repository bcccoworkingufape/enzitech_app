abstract class Failure implements Exception {
  Failure({this.message = "", this.key = ""});

  final dynamic key;
  final String message;
}
