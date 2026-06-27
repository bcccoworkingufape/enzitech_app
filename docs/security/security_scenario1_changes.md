# CENARIO 1 - Diario de mudancas por fase

Cada fase tem commit proprio no branch `OWASP-hardening`. Mensagens seguem o padrao
`tipo(escopo): descricao`.

## Fase 1 - Baseline documental (este commit)
- Arquivos novos: `docs/security/security_scenario1_checklist.md`,
  `docs/security/security_scenario1_metrics.md`,
  `docs/security/security_scenario1_changes.md`,
  `docs/security/security_scenario1_article_evidence.md`.
- Sem alteracao de codigo: o baseline "Antes" foi colhido via inspecao e `rg`.
- Commit: `docs(security): baseline CENARIO 1`.

## Fase 2 - SecureSessionStorage + logout completo
- Adicionar `flutter_secure_storage: ^9.2.2` em `pubspec.yaml`.
- Novo servico `lib/core/data/service/secure_storage/secure_session_storage.dart` (interface +
  implementacao) e migracao one-shot de token de SharedPreferences para secure storage.
- `UserPreferencesService` delega token ao `SecureSessionStorage` e remove `accessToken`
  do JSON persistido.
- `AuthRemoteDataSourceImp` deixa de salvar JSON cru em SharedPreferences.
- `SettingsViewmodel.logout()` agora e `await`-ed e limpa token + chave de cache offline
  + header Authorization no Dio.
- Commit: `feat(security): secure session storage and logout hardening`.

## Fase 3 - AppLogger sanitizado + HandleFailure seguro
- Novo `lib/core/logging/app_logger.dart` com niveis (`debug`/`info`/`warn`/`error`)
  e mascaramento de tokens/Authorization.
- `http_service_imp.dart` ganha guard `kDebugMode`; limpa interceptors antes de re-adicionar;
  nunca loga Authorization.
- `HandleFailure` default sempre retorna mensagem localizada generica; remove
  `overrideDefaultMessage: true` em `create_account_page.dart`.
- `TypeFailure` em `experiments_remote_datasource_imp.dart` nao usa mais `e.toString()`.
- Timeouts do Dio passam a lancar `NoNetworkFailure` com mensagem curta, sem stack.
- `debugPrint` em `home_page.dart` e `calculate_experiment_second_step.dart` substituidos
  por `AppLogger.warn` (compilam para no-op em release).
- Commit: `feat(security): sanitized logging and safe error messages`.

## Fase 4 - Validacao local de formularios
- Novo `lib/shared/validator/security_validators.dart` com constantes:
  `maxEmailLength = 254`, `maxPasswordLength = 128`, `maxNameLength = 120`,
  `maxDescriptionLength = 2000`, `repetitionsRange = (1, 100)`,
  `numericSampleRange = (0, 10)`, `durationRange = (1, 240)`, etc.
- Aplicacao em:
  - `login_page.dart` (email max length),
  - `create_account_first_step.dart` e `create_account_second_step.dart`
    (max length + bloqueio de avanco com `formKey.currentState!.validate()`),
  - `create_experiment_first_step.dart` (max length name/description),
  - `create_experiment_second_step.dart` (repetitions dentro de `repetitionsRange`),
  - `create_experiment_fourth_step.dart` (intervalos numericos em a/b/duration/size),
  - `calculate_experiment_second_step.dart` (limite superior em sample/whiteSample).
- Commit: `feat(security): form validation hardening`.

## Fase 5 - Rede, ambientes e pinning (stub)
- `lib/shared/utils/api.dart`: ambientes via `--dart-define=ENV=dev|stage|prod` com
  fallback prod. Allowlist temporaria documentada para `http://200.133.6.201:30001/`.
- Novo `lib/core/network/secure_network_config.dart`:
  `validateBaseUrl(url, env)` em `kReleaseMode` exige `https://`. Hook
  `CertificatePinningConfig` (stub comentado) preparado.
- `main.dart` chama `SecureNetworkConfig.validateBaseUrl(API.apiBaseUrl, ...)` apos
  `API.setEnvironment`.
- `android/app/src/main/res/xml/network_security_config.xml`:
  `cleartextTrafficPermitted="false"` no base-config; `<domain-config>` apenas para
  o IP prod; remove `<certificates src="user"/>` em release.
- `ios/Runner/Info.plist`: documentada limitacao do ATS (NSA-1) no checklist.
- Commit: `feat(security): HTTPS guard and network config`.

## Fase 6 - Protecao de interface
- Adicionar `flutter_windowmanager: ^0.2.0` em `pubspec.yaml`.
- Novo `lib/core/platform/screen_protection_service.dart` (wrapper de
  `flutter_windowmanager`) e `lib/core/platform/secure_screen_wrapper.dart`
  (mixin que chama `enable()` em `initState` e `disable()` em `dispose`; overlay
  branco em `paused`).
- Aplicado em:
  - `LoginPage`, `CreateAccountPage`,
  - `ExperimentDetailsPage`, `ExperimentResultsPage`, `CalculateExperimentPage`,
  - `SettingsPage` (com frag de conta).
- Snackbar revisado: nenhum carrega token/dados de experimento.
- Commit: `feat(security): screen protection on sensitive screens`.

## Fase 7 - Hardening de dependencias e consolidacao
- Rodar `flutter pub outdated --no-dev-dependencies`; registrar versoes criticas
  (`dio`, `shared_preferences`, `firebase_*`, `flutter_secure_storage`).
- `pretty_dio_logger` e `curl_logger_dio_interceptor` passam a registrar
  interceptors apenas com `kDebugMode` (mantidos em deps por dependencia da
  plataforma; ver nota).
- `android/app/build.gradle`: revisar `release { debuggable false }` e manter
  minify/shrink configurados (ou documentar).
- Atualizar colunas "Depois" dos 4 artefatos com valores observados.
- Commit: `docs(security): final metrics and article evidence`.

## Riscos residuais (consolidado)

| Risco | Mitigacao adotada | Trabalho futuro |
|-------|-------------------|-----------------|
| Pinning efetivo | Stub + hook de config | Implementar quando backend emitir certificado fixo |
| Cache offline | Limpeza no logout + chave dedicada | Criptografar com chave derivada do usuario |
| iOS | Documentado | Aguardar suporte equivalente (sem FLAG_SECURE nativo) |
| ATS iOS | Documentado | Forcar HTTPS no backend de producao |
