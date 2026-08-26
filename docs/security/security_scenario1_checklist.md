# CENARIO 1 - Checklist OWASP MASVS / MASTG

Escopo: Enzitech App (Flutter), branch `OWASP-hardening`. Avaliacao por
controle MASVS com referencia a arquivos do projeto. Colunas "Antes"
(estado pre-Fase 1) e "Depois" (apos Fases 2-7 + correcoes pos-Fase 7).

Convencao: `[x]` mitigado, `[~]` parcial, `[ ]` nao mitigado. A coluna
"OWASP Mobile Top 10 2024" classifica o risco; MASVS/MASTG continua sendo a
base de verificacao.

| # | Controle MASVS | OWASP Mobile Top 10 2024 | Cobertura de risco | Arquivos-chave | Antes | Apos | Observacoes |
|---|----------------|---------------------------|--------------------|----------------|-------|------|-------------|
| 1 | **STORAGE-1** Credenciais/segredos fora de SharedPreferences | M1, M9, M10 | Plena para token; parcial para segredos publicos Firebase documentados | `lib/core/data/service/user_preferences/user_preferences_service_imp.dart`, `lib/features/authentication/data/datasources/remote/auth_remote_datasource_imp.dart` | `[ ]` | `[x]` | Token migrado para `flutter_secure_storage` (EncryptedSharedPreferences no Android, Keychain no iOS). Migracao one-shot em `main.dart` -> `SecureSessionStorage.migrateFromLegacyIfNeeded`. Varredura incremental registrou 0 segredos privados versionados; `firebase_options.dart` contem API keys publicas de Firebase, tratadas como identificadores de projeto e nao como credenciais secretas. |
| 2 | **STORAGE-2** Sem dados sensiveis duplicados | M1, M9 | Plena para duplicacao de token | mesmos arquivos | `[ ]` | `[x]` | JSON `user` deixa de carregar `accessToken`; `UserPreferencesLocalDataSourceImp.getUser` remove a chave defensivamente para backward compatibility. |
| 3 | **STORAGE-2** Cache offline documentado e limpavel | M6, M9, M10 | Parcial; cache offline ainda sem criptografia | `lib/features/experiment/data/datasources/local/experiments_local_datasource_decorator_imp.dart`, `lib/features/main/data/datasources/local/user_preferences_local_datasource_imp.dart` | `[~]` | `[~]` | Mantido em SharedPreferences (trade-off offline) + chaves removidas no logout via `UserPreferencesLocalDataSourceImp.clearUser`. Criptografia fica como trabalho futuro. |
| 4 | **STORAGE-2** Logout completo | M1, M3, M9 | Plena para encerramento de sessao local | `lib/features/main/presentation/viewmodel/settings_viewmodel.dart`, `lib/core/data/service/http/http_service_imp.dart` | `[ ]` | `[x]` | `SettingsViewmodel.logout()` agora e `await`-ed: remove token do secure storage, limpa header `Authorization` + interceptors no Dio, remove caches offline (`experiments_cache`, `treatments_cache`, `enzymes_cache`) e dados de usuario. |
| 5 | **CODE-2** Logs nao vazam PII/credenciais | M1, M5, M6, M8 | Plena em release; debug sanitizado | `lib/core/data/service/http/http_service_imp.dart`, `lib/core/logging/app_logger.dart`, `lib/core/data/service/secure_storage/secure_session_storage.dart`, `lib/core/platform/screen_protection_service.dart`, `lib/features/main/presentation/ui/pages/home/home_page.dart`, `lib/features/experiment/presentation/ui/pages/calculate_experiment/fragments/calculate_experiment_second_step.dart` | `[ ]` | `[x]` | `AppLogger` sanitizado sob `kDebugMode`; `SecureSessionStorage.migrateFromLegacyIfNeeded` e `ScreenProtectionService` usam mensagens fixas via `AppLogger.warn`; interceptors Dio sensiveis so ativos em `kDebugMode && useDebugLogger`. |
| 6 | **CODE-3** Erros amigaveis (sem stack/exception) | M3, M4, M6, M8 | Plena para mensagens client-side | `lib/core/failures/handle_failures.dart`, `lib/features/experiment/data/datasources/remote/experiments_remote_datasource_imp.dart`, `lib/features/authentication/presentation/ui/pages/create_account/create_account_page.dart` | `[ ]` | `[x]` | `HandleFailure` default sempre retorna mensagem localizada generica; `overrideDefaultMessage` foi removido; `TypeFailure` em `experiments_remote_datasource_imp` nao usa mais `e.toString()`; timeouts do Dio viram `NoNetworkFailure`. |
| 7 | **CODE-4** Validacao local robusta nos formularios criticos | M4 | Plena no app; backend fora do escopo | `lib/shared/validator/security_validators.dart`, formularios de Login/Create account/Create experiment/Calculate experiment | `[~]` | `[x]` | `security_validators.dart` centraliza limites (`maxEmailLength=254`, `maxPasswordLength=128`, `maxNameLength=120`, `maxDescriptionLength=2000`, `repetitionsRange=(1,100)`, `numericSampleRange=(0,10)`, `durationRange=(1,240)`). Aplicado em login, create_account_first_step/second_step, create_experiment_first_step/second_step/fourth_step, calculate_experiment_second_step. |
| 8 | **NETWORK-1** Trafego HTTPS em producao | M5, M8 | Parcial; guard ativo, backend TLS pendente | `lib/shared/utils/api.dart`, `lib/core/network/secure_network_config.dart`, `android/app/src/main/res/xml/network_security_config.xml` | `[ ]` | `[x]` | Guarda HTTPS em `SecureNetworkConfig.validateBaseUrl` (chamado em `main.dart` apos `API.setEnvironment`). Allowlist temporaria para `http://200.133.6.201:30001/` enquanto o backend migra para TLS. Extensao adicionou `DEV_API_BASE_URL`, `STAGE_API_BASE_URL` e `PROD_API_BASE_URL` por `--dart-define`. |
| 9 | **NETWORK-2** Certificados confiaveis (pinning prep) | M5, M8, M10 | Parcial; pinning efetivo depende do certificado | `lib/core/network/secure_network_config.dart` | `[ ]` | `[~]` | Hook `CertificatePinningConfig` (stub) preparado; `spkiHashes` vazio. Pinning efetivo depende do certificado do backend. |
| 10 | **PLATFORM-9** FLAG_SECURE em telas sensiveis | M6, M7, M8 | Plena em Android; parcial em iOS por limitacao nativa | `android/app/src/main/kotlin/com/lohhans/enzitech/MainActivity.kt`, telas Login/CreateAccount/ExperimentDetails/ExperimentResults/CalculateExperiment/Settings | `[ ]` | `[x]` | `MainActivity` expoe MethodChannel `enzitech/screen_protection` (enable/disable); `flutter_windowmanager` aplicado via `ScreenProtectionService`; `SecureScreenMixin` + `wrapSecureScreen` aplicado em **7/7 telas sensiveis** (Login, CreateAccount, ExperimentDetails, ExperimentResults, CalculateExperiment, Settings). Settings corrigido pos-Fase 7. |
| 11 | **PLATFORM-10** Background overlay em pausa | M6, M8 | Plena para snapshot visual no app | `lib/core/platform/secure_screen_wrapper.dart` | `[ ]` | `[x]` | `SecureScreenMixin` ouve `WidgetsBindingObserver` e aplica overlay branco (`ColoredBox(0xFFFAFAFA)`) em `paused`/`inactive`/`hidden`. |
| 12 | **DEPENDENCIES** Versoes revisadas | M2, M7, M8 | Parcial; revisao feita, upgrades maiores pendentes | `pubspec.yaml`, `pubspec.lock`, `docs/security/security_scenario1_pub_outdated.txt` | `[~]` | `[~]` | `flutter pub outdated` registrado em `security_scenario1_pub_outdated.txt`. Loggers HTTP movidos para guard `kDebugMode` (continuam em runtime deps; mover para `dev_dependencies` fica como follow-up). |
| 13 | **CODE-4** Politica de retries/backoff sensivel | M4, M5, M8 | Plena no tratamento client-side | `lib/core/data/service/http/http_service_imp.dart` | `[ ]` | `[x]` | Timeouts do Dio viram `NoNetworkFailure` generico; nao ha mais exposicao de `dioError.message` cru. |
| 14 | **CODE-2 / STORAGE-1** Varredura explicita de segredos hardcoded | M1, M2, M8, M9, M10 | Plena para segredos privilegiados no app | `docs/security/security_scenario1_secret_scan.md`, `lib/firebase_options.dart` | `[ ]` | `[x]` | Extensao Mobile Top 10 registrou scan explicito: 0 segredos privilegiados hardcoded; 3 Firebase client API keys triadas como identificadores publicos de cliente, com regras Firebase/backend fora do escopo. |
| 15 | **CONFIG / NETWORK-1** Parametrizacao segura de endpoints por build | M5, M8 | Parcial por backend legado | `lib/shared/utils/api.dart` | `[~]` | `[x]` | Builds podem definir `DEV_API_BASE_URL`, `STAGE_API_BASE_URL` e `PROD_API_BASE_URL` via `--dart-define`; o fallback legado foi preservado e continua controlado por `SecureNetworkConfig`. |

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

## Resumo por OWASP Mobile Top 10 2024

| Risco | Cobertura CENARIO 1 | Lacunas residuais |
|-------|----------------------|-------------------|
| M1 - Improper Credential Usage | Token em secure storage, remocao do token do JSON persistido, logout completo e scan de segredos com 0 segredos privilegiados. | Firebase client API keys permanecem como configuracao publica; revisar regras Firebase/backend fora do escopo. |
| M2 - Inadequate Supply Chain Security | `flutter pub outdated` registrado, dependencias sensiveis identificadas e loggers HTTP guardados por `kDebugMode`. | Upgrades maiores, SBOM, SCA automatizado e revisao de regras Firebase ficam como futuro. |
| M3 - Insecure Authentication/Authorization | Sessao local limpa no logout, header `Authorization` removido e erros de token tratados sem vazamento. | Politicas de autorizacao do backend fora do escopo. |
| M4 - Insufficient Input/Output Validation | Validadores locais centralizados para formularios criticos e mensagens de erro seguras. | Validacao server-side nao verificada neste cenario. |
| M5 - Insecure Communication | Guard HTTPS, network security config restritiva, logs HTTP reduzidos e endpoints parametrizaveis por build. | Backend de producao ainda usa HTTP legado em allowlist; pinning efetivo pendente. |
| M6 - Inadequate Privacy Controls | FLAG_SECURE/overlay, minimizacao de logs e mensagens amigaveis. | Cache offline ainda sem criptografia; protecao nativa equivalente no iOS documentada como limitacao. |
| M7 - Insufficient Binary Protections | Release Android com `debuggable false`, protecao visual Android e revisao de build. | Obfuscation/minify/RASP/anti-tamper nao implementados para evitar risco de quebra nesta extensao. |
| M8 - Security Misconfiguration | Cleartext global restringido, excecao explicita, guard de ambiente e `--dart-define` para URL segura. | Remover allowlist quando TLS do backend estiver disponivel; automatizar policy checks de CI. |
| M9 - Insecure Data Storage | Token fora de SharedPreferences, sem duplicacao em JSON e limpeza de caches no logout. | Cache offline permanece em SharedPreferences por requisito offline. |
| M10 - Insufficient Cryptography | Secure storage usa Keystore/Keychain; pinning stub preparado. | Criptografia do cache offline e pins SPKI reais ficam como futuro. |
