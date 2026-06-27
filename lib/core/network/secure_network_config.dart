// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 🌎 Project imports:
import '../enums/enviroment_enum.dart';

/// Network hardening entry points used at app startup.
///
/// The HTTPS guard is the only mandatory check today. A pinning
/// configuration hook is included as a stub so the call site is stable and
/// the actual pins can be wired up once the backend certificate is final.
class SecureNetworkConfig {
  SecureNetworkConfig._();

  /// Temporary allow-list of cleartext endpoints that have not yet migrated
  /// to TLS. Each entry must be removed as soon as the backend ships HTTPS.
  static const _legacyCleartextAllowList = <String>{
    'http://200.133.6.201:30001/',
  };

  /// Validates the chosen base URL for the target environment.
  ///
  /// Release builds must use HTTPS for production. Dev/stage may keep HTTP
  /// to support local network debugging.
  ///
  /// The legacy cleartext IP for prod remains allowed as a documented
  /// exception while the backend migration is pending.
  static void validateBaseUrl(String baseUrl, EnvironmentEnum environment) {
    final isHttps = baseUrl.toLowerCase().startsWith('https://');
    final isAllowedCleartext = _legacyCleartextAllowList.contains(baseUrl);

    if (kReleaseMode && environment == EnvironmentEnum.prod && !isHttps && !isAllowedCleartext) {
      throw StateError(
        'Refusing to start: production base URL must use HTTPS. Got: $baseUrl',
      );
    }
  }

  /// Certificate pinning configuration. Stub for now; pass real SPKI hashes
  /// once the backend certificate is finalised.
  static CertificatePinningConfig pinningFor(EnvironmentEnum environment) {
    // TODO(security): when the backend certificate is stable, populate the
    // SPKI pin list for each environment. Until then, return an empty config.
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
        //* Pinning is not enabled yet. Add hashes here once available.
        return const CertificatePinningConfig(spkiHashes: <String>[]);
    }
  }
}
