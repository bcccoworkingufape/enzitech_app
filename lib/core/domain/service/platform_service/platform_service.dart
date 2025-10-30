// 🌎 Project imports:
import '../../../enums/platform_type_enum.dart';

abstract class PlatformService {
  bool get isWeb;

  bool get isIOS;

  bool get isAndroid;

  bool get isMacOS;

  bool get isWindows;

  bool get isLinux;

  PlatformTypeEnum getPlatformType();
}
