import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import '../../../domain/service/platform_service/platform_service.dart';
import '../../../enums/platform_type_enum.dart';

class PlatformServiceImp implements PlatformService {
  @override
  bool get isWeb => kIsWeb;

  @override
  bool get isIOS => !kIsWeb && Platform.isIOS;

  @override
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  bool get isMacOS => !kIsWeb && Platform.isMacOS;

  @override
  bool get isWindows => !kIsWeb && Platform.isWindows;

  @override
  bool get isLinux => !kIsWeb && Platform.isLinux;

  @override
  PlatformTypeEnum getPlatformType() {
    if (isWeb) {
      return PlatformTypeEnum.web;
    } else if (isIOS) {
      return PlatformTypeEnum.iOS;
    } else if (isAndroid) {
      return PlatformTypeEnum.android;
    } else if (isMacOS) {
      return PlatformTypeEnum.macOS;
    } else if (isWindows) {
      return PlatformTypeEnum.windows;
    } else if (isLinux) {
      return PlatformTypeEnum.linux;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
