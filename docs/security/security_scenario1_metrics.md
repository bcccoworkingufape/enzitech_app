| # | Métrica | Valor Antes | Valor Depois (Fase 7) |
|---|---------|-------------|------------------------|
| M1 | Locais que armazenam token de forma insegura | **2** (`token` em SharedPreferences + `accessToken` dentro do JSON `user`) | **0** (token em `flutter_secure_storage`; JSON `user` agora sem `accessToken`) |
| M2 | Mecanismo de armazenamento sensível | **SharedPreferences** (0 secure storage) | **flutter_secure_storage** com `AndroidOptions(encryptedSharedPreferences: true)` |
| M3 | Logs sensíveis explícitos ativos em release | **0** (interceptors off), 2 `debugPrint`, infra latente 2 interceptors | **0** ativos em release; loggers Dio guardados por `kDebugMode`; `debugPrint` substituídos por `AppLogger` (compila para no-op em release) |
| M4 | Formulários críticos com validação local completa | **5/6 parcial** | **6/6** (login, create account 2 steps, create experiment 4 steps, calculate experiment) |
| M5 | Telas sensíveis protegidas (FLAG_SECURE) | **0/7** | **6/7** (Login, Create Account, Experiment Details, Experiment Results, Calculate Experiment, Settings - Android via MainActivity FLAG_SECURE + mixin SecureScreenMixin) |
| M6 | Pontos com mensagem de erro potencialmente insegura | **~4** | **0** (HandleFailure default sem `failure.message`, `overrideDefaultMessage` removido, `TypeFailure` sem `e.toString()`, timeouts viram `NoNetworkFailure` vazio) |
| M7 | Produção usa HTTPS | **Não** | **Guarda HTTPS** ativa (`SecureNetworkConfig.validateBaseUrl`) + allowlist documentada para IP legacy (`http://200.133.6.201:30001/`) até migração TLS |
| M8 | Guarda HTTPS implementada | **Não** | **1** guarda (`lib/core/network/secure_network_config.dart`) |
| M9 | Cleartext Android global | **Permitido** (base-config true + user CAs) | **Desligado** (`cleartextTrafficPermitted="false"`); exceção explícita apenas para `200.133.6.201` |
| M10 | Pinning efetivo | **Não** | **Stub** (`CertificatePinningConfig` preparado) |
| M11 | Dependências críticas sem hardening | `shared_preferences` para segredos, `pretty_dio_logger`/`curl_logger_dio_interceptor` em runtime deps | Loggers HTTP guardados por `kDebugMode`; `flutter_secure_storage` introduzido. Versões atuais: `dio 5.9.0`, `shared_preferences 2.5.3`, `firebase_core 4.0.0`, `firebase_crashlytics 5.0.0`, `flutter_secure_storage 9.2.4` (ver `flutter pub outdated`) |
| M12 | Documentação OWASP para artigo IEEE | 0 páginas | **4 artefatos** em `docs/security/` (checklist, métricas, mudanças, evidência metodológica) ≈ 8 páginas |

