// 🐦 Flutter imports:
import 'package:flutter/material.dart';

abstract class IDisposableProvider with ChangeNotifier {
  void disposeValues();
}
