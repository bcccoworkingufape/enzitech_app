// 🌎 Project imports:
import '../../shared/l10n/app_localizations.dart';
import 'failures.dart';

class HandleFailure {
  /// Traduz um [Failure] em uma mensagem localizada e voltada ao usuário.
  ///
  /// Política de segurança: o caminho padrão nunca expõe a mensagem bruta de falha
  /// retornada pelo backend (que pode vazar dicas de validação,
  /// detalhes de stack ou estado interno). Falhas conhecidas específicas (por exemplo,
  /// "connection refused") ainda são mapeadas para frases localizadas.
  ///
  /// Os flags legados `enableStatusCode` / `overrideDefaultMessage` eram padrões
  /// inseguros e agora são ignorados; os chamadores que antes dependiam deles
  /// devem usar os campos estruturados em `Failure` (por exemplo, `key`) e
  /// apresentar apenas o que o dicionário de l10n já suporta.
  static String of(
    AppLocalizations l10n,
    Failure failure, {
    bool enableStatusCode = false,
    bool overrideDefaultMessage = false,
    bool isLogin = false,
  }) {
    //* Erro personalizado do EZT quando a API estiver indisponível
    if (failure.runtimeType is ServerFailure) {
      if (failure.message.contains("Connection refused")) {
        return l10n.error_serverConnectionRefused;
      }
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
            // Fallback final: uma mensagem genérica e sem vazamento de detalhes.
            return l10n.error_messageOnly('');
        }
    }
  }
}
