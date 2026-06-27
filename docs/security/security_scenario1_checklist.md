# CENARIO 1 - Checklist OWASP MASVS / MASTG (Baseline)

Escopo: app Enzitech (Flutter, branch `OWASP-hardening`). Avaliacao por controle MASVS, com
referencias a arquivos do projeto. Colunas "Antes" (estado atual) e "Depois" (apos as 7 fases).

Convencao: [x] = mitigado, [~] = parcial, [ ] = nao mitigado.

| # | Controle MASVS | Arquivos-chave | Antes | Apos Fases | Observacoes |
|---|----------------|----------------|-------|-----------|-------------|
| 1 | **STORAGE-1** Credenciais/segredos fora de SharedPreferences | `lib/core/data/service/user_preferences/user_preferences_service_imp.dart`, `lib/features/authentication/data/datasources/remote/auth_remote_datasource_imp.dart` | [ ] | [x] | Token migrado para `flutter_secure_storage` (EncryptedSharedPreferences no Android). |
| 2 | **STORAGE-2** Sem dados sensiveis duplicados | mesmos arquivos acima | [ ] | [x] | JSON `user` deixa de carregar `accessToken`. |
| 3 | **STORAGE-2** Cache offline documentado e limpavel | `lib/features/experiment/data/datasources/local/experiments_local_datasource_decorator_imp.dart` | [~] | [~] | Mantido em SharedPreferences (trade-off offline) + chave limpa no logout. |
| 4 | **STORAGE-2** Logout completo | `lib/features/main/presentation/viewmodel/settings_viewmodel.dart`, `lib/core/data/service/http/http_service_imp.dart` | [ ] | [x] | `clearUser` awaited; header Dio limpo; caches em memoria descartados. |
| 5 | **CODE-2** Logs nao vazam PII/credenciais | `lib/core/data/service/http/http_service_imp.dart`, `lib/features/main/presentation/ui/pages/home/home_page.dart`, `lib/features/experiment/presentation/ui/pages/calculate_experiment/fragments/calculate_experiment_second_step.dart` | [ ] | [x] | `AppLogger` sanitizado; `debugPrint` removidos; interceptors Dio sensiveis so em `kDebugMode`. |
| 6 | **CODE-3** Erros amigaveis (sem stack/exception) | `lib/core/failures/handle_failures.dart`, `lib/features/experiment/data/datasources/remote/experiments_remote_datasource_imp.dart`, `lib/features/authentication/presentation/ui/pages/create_account/create_account_page.dart` | [ ] | [x] | `HandleFailure` default generico; `overrideDefaultMessage: true` removido. |
| 7 | **CODE-4** Validacao local robusta nos formularios criticos | `lib/shared/validator/field_validator.dart`, formularios de Login/Create account/Create experiment/Calculate experiment | [~] | [x] | `security_validators.dart` aplica max length e intervalos numericos. |
| 8 | **NETWORK-1** Trafego HTTPS em producao | `lib/shared/utils/api.dart`, `android/app/src/main/res/xml/network_security_config.xml` | [ ] | [x] | Guarda HTTPS em `SecureNetworkConfig`; allowlist temporaria documentada; cleartext Android desligado global. |
| 9 | **NETWORK-2** Certificados confiaveis (pining prep) | novo `lib/core/network/secure_network_config.dart` | [ ] | [~] | Hook `CertificatePinningConfig` (stub) preparado; pining efetivo fica para trabalho futuro. |
| 10 | **PLATFORM-9** FLAG_SECURE em telas sensiveis | `android/app/src/main/kotlin/com/lohhans/enzitech/MainActivity.kt`, telas Login/CreateAccount/ExperimentDetails/ExperimentResults/CalculateExperiment/Settings | [ ] | [x] | `flutter_windowmanager` aplicado em 6-7 telas (Android); iOS documentado. |
| 11 | **PLATFORM-10** Background overlay em pausa | idem | [ ] | [x] | Overlay branco no `WidgetsBindingObserver` do `SecureScreenWrapper`. |
| 12 | **DEPENDENCIES** Versoes revisadas | `pubspec.yaml` | [~] | [~] | `flutter pub outdated` registrado; loggers HTTP movidos para guard `kDebugMode`. |
| 13 | **CODE-4** Politica de retries/backoff sensivel | nao existente | [ ] | [x] | Timeouts e mensagens de timeout agora traduzidas para `NoNetworkFailure` generico. |

Notas:

- iOS: ATS bloqueia HTTP por padrao; limitacao documentada (NSA-1).
- Pinning efetivo: stub preparatorio; execucao depende de certificado backend.
- Cache offline: trade-off explicito (sem criptografia); limpeza garantida no logout.
