// 🌎 Project imports:
import '../../shared/l10n/app_localizations.dart';
import 'failures.dart';

class HandleFailure {
  static String of(
    AppLocalizations l10n,
    Failure failure, {
    bool enableStatusCode = false,
    bool overrideDefaultMessage = false,
    bool isLogin = false,
  }) {
    //* EZT custom error when API is down
    if (failure.runtimeType is ServerFailure) {
      if (failure.message.contains("Connection refused")) {
        return l10n.error_serverConnectionRefused;
      }
    }

    if (overrideDefaultMessage) {
      return enableStatusCode
          ? l10n.error_statusCodeAndMessage(failure.key.toString(), failure.message)
          : l10n.error_messageOnly(failure.message);
    }

    switch (failure.key) {
      case 400:
        return l10n.error_400;
      case 401:
        return l10n.error_401;
      case 403:
        return l10n.error_403;
      case 404:
        return isLogin ? l10n.error_404_login : l10n.error_404_generic;
      case 422:
        return l10n.error_422;
      case 426:
        return l10n.error_426;
      case 500:
        return l10n.error_500;
      case 503:
        return l10n.error_503;
      default:
        switch (failure.runtimeType) {
          case NoNetworkFailure _:
            return l10n.error_noNetwork;
          case NoResultQueryFailure _:
            return l10n.error_noResultQuery(failure.message.toLowerCase());
          default:
            return enableStatusCode
                ? l10n.error_statusCodeAndMessage(failure.key.toString(), failure.message)
                : l10n.error_messageOnly(failure.message);
        }
    }
  }
}
