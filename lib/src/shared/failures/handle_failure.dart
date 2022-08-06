import 'failures.dart';

class HandleFailure {
  static String of(Failure failure) {
    switch (failure.key) {
      case 400:
        return "⚠ Dados incorretos: Algum campo inválido ou ausente.";
      case 401:
        return "⚠ Não autorizado: Token expirado ou usuário inválido.";
      case 403:
        return "⚠ Acesso negado: Você não tem permissão para executar esta ação.";
      case 404:
        return "⚠ Não encontrado: Talvez essa infromação não exista mais.";
      case 422:
        return "⚠ Entidade não processável: Não foi possível processar as instruções presentes.";
      case 500:
        return "⚠ Erro do Servidor: Não foi possível atender à solicitação.";
      case 503:
        return "⚠ Erro do Servidor: Não foi possível atender à solicitação neste momento.";
      case 426:
        return "⚠ Upgrade requerido: ID de dispositivo inválido.";
      default:
        return "⚠ ${failure.message}";
    }
  }
}
