// 🌎 Project imports:
import '../../shared/l10n/app_localizations.dart';
import 'failures.dart';

class HandleFailure {
  /// Traduz um [Failure] em uma mensagem localizada e voltada ao usuário.
  ///
  /// Política de segurança: por padrão, nunca expõe a mensagem bruta de falha
  /// retornada pelo backend (que pode vazar dicas de validação,
  /// detalhes de stack ou estado interno). Falhas conhecidas específicas (por exemplo,
  /// "connection refused") ainda são mapeadas para frases localizadas.
  ///
  /// `overrideDefaultMessage: true` é uma exceção explícita para telas cujo
  /// backend já retorna mensagens curadas e seguras (ex.: fluxo de recuperação
  /// de senha) — nesse caso a mensagem real do backend é exibida no lugar do
  /// texto genérico por status HTTP.
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

    if (overrideDefaultMessage) {
      final knownMessage = _knownBackendMessage(l10n, failure.message);
      if (knownMessage != null) return knownMessage;
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
      case 502:
        return l10n.error_502;
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

  /// Mapeia mensagens curadas conhecidas retornadas pelo backend (sempre em
  /// português, já que a API não é internacionalizada) para a string
  /// localizada correspondente. Retorna `null` para mensagens não mapeadas.
  static String? _knownBackendMessage(AppLocalizations l10n, String rawMessage) {
    switch (rawMessage.trim()) {
      case "O e-mail não está cadastrado em nossa base de dados.":
        return l10n.error_emailNotRegistered;
      case "Código inválido.":
        return l10n.error_invalidCode;
      case "Código inválido ou não encontrado.":
        return l10n.error_invalidOrNotFoundCode;
      case "O código expirou. Por favor, solicite um novo.":
        return l10n.error_codeExpired;
      case "A nova senha não pode ser igual à senha atual.":
        return l10n.error_newPasswordSameAsCurrent;
      default:
        return null;
    }
  }
}
