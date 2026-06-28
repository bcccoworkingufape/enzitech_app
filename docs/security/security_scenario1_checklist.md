# CENARIO 1 - Checklist OWASP MASVS / MASTG

Escopo: Enzitech App (Flutter), branch `OWASP-hardening`. Avaliacao por
controle MASVS com referencia a arquivos do projeto. Colunas "Antes"
(estado pre-Fase 1) e "Depois" (apos Fases 2-7 + correcoes pos-Fase 7).

Convencao: `[x]` mitigado, `[~]` parcial, `[ ]` nao mitigado.

| # | Controle MASVS | Arquivos-chave | Antes | Apos | Observacoes |
|---|----------------|----------------|-------|------|-------------|
| 1 | **STORAGE-1** Credenciais/segredos fora de SharedPreferences | `lib/core/data/service/user_preferences/user_preferences_service_imp.dart`, `lib/features/authentication/data/datasources/remote/auth_remote_datasource_imp.dart` | `[ ]` | `[x]` | Token migrado para `flutter_secure_storage` (EncryptedSharedPreferences no Android, Keychain no iOS). Migracao one-shot em `main.dart` -> `SecureSessionStorage.migrateFromLegacyIfNeeded`. |
| 2 | **STORAGE-2** Sem dados sensiveis duplicados | mesmos arquivos | `[ ]` | `[x]` | JSON `user` deixa de carregar `accessToken`; `UserPreferencesLocalDataSourceImp.getUser` remove a chave defensivamente para backward compatibility. |
| 3 | **STORAGE-2** Cache offline documentado e limpavel | `lib/features/experiment/data/datasources/local/experiments_local_datasource_decorator_imp.dart`, `lib/features/main/data/datasources/local/user_preferences_local_datasource_imp.dart` | `[~]` | `[~]` | Mantido em SharedPreferences (trade-off offline) + chaves removidas no logout via `UserPreferencesLocalDataSourceImp.clearUser`. Criptografia fica como trabalho futuro. |
| 4 | **STORAGE-2** Logout completo | `lib/features/main/presentation/viewmodel/settings_viewmodel.dart`, `lib/core/data/service/http/http_service_imp.dart` | `[ ]` | `[x]` | `SettingsViewmodel.logout()` agora e `await`-ed: remove token do secure storage, limpa header `Authorization` + interceptors no Dio, remove caches offline (`experiments_cache`, `treatments_cache`, `enzymes_cache`) e dados de usuario. |
| 5 | **CODE-2** Logs nao vazam PII/credenciais | `lib/core/data/service/http/http_service_imp.dart`, `lib/core/logging/app_logger.dart`, `lib/core/data/service/secure_storage/secure_session_storage.dart`, `lib/features/main/presentation/ui/pages/home/home_page.dart`, `lib/features/experiment/presentation/ui/pages/calculate_experiment/fragments/calculate_experiment_second_step.dart` | `[ ]` | `[x]` | `AppLogger` sanitizado sob `kDebugMode`; `SecureSessionStorage.migrateFromLegacyIfNeeded` substituiu `debugPrint` por `AppLogger.warn` (correcao pos-Fase 7); interceptors Dio sensiveis so ativos em `kDebugMode && useDebugLogger`. |
| 6 | **CODE-3** Erros amigaveis (sem stack/exception) | `lib/core/failures/handle_failures.dart`, `lib/features/experiment/data/datasources/remote/experiments_remote_datasource_imp.dart`, `lib/features/authentication/presentation/ui/pages/create_account/create_account_page.dart` | `[ ]` | `[x]` | `HandleFailure` default sempre retorna mensagem localizada generica; `overrideDefaultMessage` foi removido; `TypeFailure` em `experiments_remote_datasource_imp` nao usa mais `e.toString()`; timeouts do Dio viram `NoNetworkFailure`. |
| 7 | **CODE-4** Validacao local robusta nos formularios criticos | `lib/shared/validator/security_validators.dart`, formularios de Login/Create account/Create experiment/Calculate experiment | `[~]` | `[x]` | `security_validators.dart` centraliza limites (`maxEmailLength=254`, `maxPasswordLength=128`, `maxNameLength=120`, `maxDescriptionLength=2000`, `repetitionsRange=(1,100)`, `numericSampleRange=(0,10)`, `durationRange=(1,240)`). Aplicado em login, create_account_first_step/second_step, create_experiment_first_step/second_step/fourth_step, calculate_experiment_second_step. |
| 8 | **NETWORK-1** Trafego HTTPS em producao | `lib/shared/utils/api.dart`, `lib/core/network/secure_network_config.dart`, `android/app/src/main/res/xml/network_security_config.xml` | `[ ]` | `[x]` | Guarda HTTPS em `SecureNetworkConfig.validateBaseUrl` (chamado em `main.dart` apos `API.setEnvironment`). Allowlist temporaria para `http://200.133.6.201:30001/` enquanto o backend migra para TLS. |
| 9 | **NETWORK-2** Certificados confiaveis (pinning prep) | `lib/core/network/secure_network_config.dart` | `[ ]` | `[~]` | Hook `CertificatePinningConfig` (stub) preparado; `spkiHashes` vazio. Pinning efetivo depende do certificado do backend. |
| 10 | **PLATFORM-9** FLAG_SECURE em telas sensiveis | `android/app/src/main/kotlin/com/lohhans/enzitech/MainActivity.kt`, telas Login/CreateAccount/ExperimentDetails/ExperimentResults/CalculateExperiment/Settings | `[ ]` | `[x]` | `MainActivity` expoe MethodChannel `enzitech/screen_protection` (enable/disable); `flutter_windowmanager` aplicado via `ScreenProtectionService`; `SecureScreenMixin` + `wrapSecureScreen` aplicado em **7/7 telas sensiveis** (Login, CreateAccount, ExperimentDetails, ExperimentResults, CalculateExperiment, Settings). Settings corrigido pos-Fase 7. |
| 11 | **PLATFORM-10** Background overlay em pausa | `lib/core/platform/secure_screen_wrapper.dart` | `[ ]` | `[x]` | `SecureScreenMixin` ouve `WidgetsBindingObserver` e aplica overlay branco (`ColoredBox(0xFFFAFAFA)`) em `paused`/`inactive`/`hidden`. |
| 12 | **DEPENDENCIES** Versoes revisadas | `pubspec.yaml`, `docs/security/security_scenario1_pub_outdated.txt` | `[~]` | `[~]` | `flutter pub outdated` registrado em `security_scenario1_pub_outdated.txt`. Loggers HTTP movidos para guard `kDebugMode` (continuam em runtime deps; mover para `dev_dependencies` fica como follow-up). |
| 13 | **CODE-4** Politica de retries/backoff sensivel | `lib/core/data/service/http/http_service_imp.dart` | `[ ]` | `[x]` | Timeouts do Dio viram `NoNetworkFailure` generico; nao ha mais exposicao de `dioError.message` cru. |

## Notas finais

- iOS: ATS bloqueia HTTP por padrao; sem FLAG_SECURE nativo equivalente
  (limitacao documentada como NSA-1). Telas iOS ainda se beneficiam do guard
  HTTPS via `validateBaseUrl` e dos formularios validados.
- Pinning efetivo: stub preparatorio; execucao depende de coordenacao com o
  backend.
- Cache offline: trade-off explicito (sem criptografia); limpeza garantida no
  logout.

## Conformidade MASVS consolidada

| Categoria | Controles | Estado |
|-----------|-----------|--------|
| STORAGE | 4 | 3 plenos + 1 parcial (cache offline) |
| CODE | 4 | 4 plenos |
| NETWORK | 2 | 1 pleno + 1 parcial (pinning stub) |
| PLATFORM | 2 | 2 plenos |
| DEPENDENCIES | 1 | parcial (versoes revisadas, mas sem mover loggers para dev_dependencies) |
