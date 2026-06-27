# CENARIO 1 - Metricas Antes / Depois

Metricas mensuraveis, com metodo de coleta e valores ao final do baseline.
A coluna "Depois" e preenchida na Fase 7 com os valores observados.

| # | Metrica | Valor Antes | Como medir | Valor Depois (Fase 7) |
|---|---------|-------------|------------|------------------------|
| M1 | Locais que armazenam token de forma insegura | **2** (`token` em SharedPreferences + `accessToken` dentro do JSON `user`) | `rg "_tokenKey|_userKey" lib` + `rg "accessToken" lib` | **0** (token em `flutter_secure_storage`) |
| M2 | Mecanismo de armazenamento sensivel | **SharedPreferences** (0 secure storage) | inspecao de deps e servicos | **flutter_secure_storage (Android EncryptedSharedPreferences)** |
| M3 | Logs sensiveis explicitos ativos em release | **0** (interceptors off), mas `pretty_dio_logger`/`curl_logger_dio_interceptor` em runtime deps + `debugPrint` em 2 arquivos | `rg "print\\(|debugPrint\\(" lib` + `pubspec.yaml` | **0** ativos em release (movidos/guardados por `kDebugMode`) |
| M4 | Formularios criticos com validacao local completa | **5/6 parcial** (login, cadastro, create experiment, calculate experiment) | inspecao de `lib/features/**/presentation/ui/pages/**` | **6/6** |
| M5 | Telas sensiveis protegidas (FLAG_SECURE) | **0/7** | `rg "flutter_windowmanager|SecureScreenWrapper" lib` | **6-7/7 (Android)**, iOS documentado |
| M6 | Pontos com mensagem de erro potencialmente insegura | **~4** (`HandleFailure` default com `failure.message`, `TypeFailure(e.toString())`, `overrideDefaultMessage: true` em create_account, timeouts tecnicos) | `rg "failure.message|e.toString()|overrideDefaultMessage" lib` | **0** |
| M7 | Producao usa HTTPS | **Nao** (`http://200.133.6.201:30001/`) | `lib/shared/utils/api.dart` | **Guarda HTTPS** + allowlist documentada (TLS backend pendente) |
| M8 | Guarda HTTPS implementada | **Nao** | novo `lib/core/network/secure_network_config.dart` | **Sim** (1 guarda) |
| M9 | Cleartext Android global | **Permitido** (`network_security_config.xml` base-config true + `<certificates src="user"/>`) | `android/app/src/main/res/xml/network_security_config.xml` | **Desligado** (excecao explicita apenas para o IP prod) |
| M10 | Pinning efetivo (cert pinning) | **Nao** | novo stub `CertificatePinningConfig` | **Stub preparatorio** (1) |
| M11 | Dependencias criticas sem hardening | `shared_preferences` para secrets, `pretty_dio_logger`/`curl_logger_dio_interceptor` em runtime deps | `pubspec.yaml` | `pretty_dio_logger`/`curl_logger_dio_interceptor` guardados por `kDebugMode` |
| M12 | Documentacao OWASP para artigo IEEE | 0 paginas | novo `docs/security/` | **>= 6 paginas de evidencia** (4 artefatos principais) |

## Metodo de coleta (resumo)

- Inspecao manual + `rg` para localizar termos sensiveis.
- `flutter pub outdated --no-dev-dependencies` para M11/M12.
- Teste manual de login/logout/relogin para confirmar migracao do token (M1, M4).
- Emulador Android com adb screencap para validar FLAG_SECURE (M5).
- Diff `git diff HEAD~7 HEAD -- pubspec.yaml` para M11.

## Limitacoes assumidas

- Pinning efetivo depende do certificado do backend; mantemos stub.
- Cache offline nao criptografado (trade-off de UX); chave limpavel.
- iOS: sem FLAG_SECURE nativo (limitacao de plataforma documentada).
