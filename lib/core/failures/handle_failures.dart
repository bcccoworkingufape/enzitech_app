// 🌎 Project imports:
import 'failures.dart';

class HandleFailure {
  static String of(
    Failure failure, {
    bool enableStatusCode = false,
    bool overrideDefaultMessage = false,
    bool isLogin = false,
  }) {
    // EZT custom error when API is down
    if (failure.runtimeType is ServerFailure) {
      if (failure.message.contains("Connection refused")) {
        return "⚠ Erro de Servidor, tente novamente mais tarde.";
      }
    }

    if (overrideDefaultMessage) {
      return enableStatusCode
          ? "⚠ SC${failure.key} - ${failure.message}"
          : "⚠ ${failure.message}";
    }

    switch (failure.key) {
      case 400:
        return "⚠ Dados incorretos: Algum campo inválido ou ausente.";
      case 401:
        return "⚠ Não autorizado: Token expirado ou usuário inválido.";
      case 403:
        return "⚠ Acesso negado: Você não tem permissão para executar esta ação.";
      case 404:
        if (isLogin) {
          return "⚠ Usuário não encontrado.";
        } else {
          return "⚠ Não encontrado: Talvez essa informação não exista mais.";
        }
      case 422:
        return "⚠ Entidade não processável: Não foi possível processar as instruções presentes.";
      case 426:
        return "⚠ Upgrade requerido: ID de dispositivo inválido.";
      case 500:
        return "⚠ Erro do Servidor: Não foi possível atender à solicitação.";
      case 503:
        return "⚠ Erro do Servidor: Não foi possível atender à solicitação neste momento.";
      default:
        switch (failure.runtimeType) {
          case NoNetworkFailure:
            return "⚠ Sem conexão com a internet, verfique seu acesso à rede e tente novamente.";
          case NoResultQueryFailure:
            return "⚠ Não foi possível obter ${(failure.message).toLowerCase()}.";
          default:
            return enableStatusCode
                ? "⚠ SC${failure.key} - ${failure.message}"
                : "⚠ ${failure.message}";
        }
    }
  }
}
