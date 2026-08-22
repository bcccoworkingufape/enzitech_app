// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 🌎 Project imports:
import '../enums/enviroment_enum.dart';

/// Pontos de entrada de hardening de rede usados na inicialização do app.
///
/// O guard de HTTPS é a única verificação obrigatória hoje. Um hook de
/// configuração de pinning está incluído como stub para que o ponto de chamada
/// fique estável e os pins reais possam ser conectados quando o certificado do backend for finalizado.
class SecureNetworkConfig {
  SecureNetworkConfig._();

  /// Lista temporária de permissões de endpoints em texto puro que ainda não migraram
  /// para TLS. Cada entrada deve ser removida assim que o backend disponibilizar HTTPS.
  static const _legacyCleartextAllowList = <String>{'http://200.133.6.201:30001/'};

  /// Valida a URL base escolhida para o ambiente de destino.
  ///
  /// Builds de release devem usar HTTPS para produção. Dev/stage podem manter HTTP
  /// para suportar depuração local de rede.
  ///
  /// O IP legado em texto puro para produção permanece permitido como exceção documentada
  /// enquanto a migração do backend está pendente.
  static void validateBaseUrl(String baseUrl, EnvironmentEnum environment) {
    final isHttps = baseUrl.toLowerCase().startsWith('https://');
    final isAllowedCleartext = _legacyCleartextAllowList.contains(baseUrl);

    if (kReleaseMode && environment == EnvironmentEnum.prod && !isHttps && !isAllowedCleartext) {
      throw StateError('Refusing to start: production base URL must use HTTPS. Got: $baseUrl');
    }
  }

  /// Configuração de pinning de certificado. Stub por enquanto; passe hashes SPKI reais
  /// quando o certificado do backend for finalizado.
  static CertificatePinningConfig pinningFor(EnvironmentEnum environment) {
    // TODO(security): quando o certificado do backend estiver estável, preencha a
    // lista de pins SPKI para cada ambiente. Até lá, retorne uma configuração vazia.
    return CertificatePinningConfig.forEnvironment(environment);
  }
}

class CertificatePinningConfig {
  const CertificatePinningConfig({required this.spkiHashes});

  final List<String> spkiHashes;

  factory CertificatePinningConfig.forEnvironment(EnvironmentEnum environment) {
    switch (environment) {
      case EnvironmentEnum.dev:
      case EnvironmentEnum.stage:
      case EnvironmentEnum.prod:
        //* O pinning ainda não está habilitado. Adicione hashes aqui quando estiverem disponíveis.
        return const CertificatePinningConfig(spkiHashes: <String>[]);
    }
  }
}
