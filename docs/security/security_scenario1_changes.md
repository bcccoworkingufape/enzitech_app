# CENARIO 1 - Diario de mudancas por fase

Cada fase tem commit proprio no branch `OWASP-hardening`. Mensagens seguem o
padrao `tipo(escopo): descricao`.

Para a extensao OWASP Mobile Top 10 2024, cada fase tambem registra:
MASVS relacionado, Mobile Top 10 relacionado, impacto tecnico e impacto
metodologico no artigo. O historico MASVS/MASTG permanece a base de controle;
Mobile Top 10 e usado como classificacao de risco.

## Fase 1 - Baseline documental (commit `1b3d292`)

- Arquivos novos em `docs/security/`:
  - `security_scenario1_checklist.md`
  - `security_scenario1_metrics.md`
  - `security_scenario1_changes.md`
  - `security_scenario1_article_evidence.md`
- Sem alteracao de codigo: o baseline "Antes" foi colhido via inspecao + `rg`.
- Commit: `docs(security): baseline CENARIO 1`.

Mapeamento desta fase:

- MASVS relacionado: STORAGE, CODE, NETWORK, PLATFORM, DEPENDENCIES.
- Mobile Top 10 relacionado: M1-M10, como taxonomia de risco posterior.
- Impacto tecnico: nenhum codigo alterado; criacao da linha de base para
  comparacao antes/depois.
- Impacto metodologico no artigo: define o desenho quase-experimental do
  CENARIO 1, com baseline auditavel por artefatos.

## Fase 2 - SecureSessionStorage + logout completo (commit `d9f043f`)

- Adicionar `flutter_secure_storage: ^9.2.2` em `pubspec.yaml`.
- Novo servico `lib/core/data/service/secure_storage/secure_session_storage.dart`
  (interface + impl) com `AndroidOptions(encryptedSharedPreferences: true)` e
  `IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device)`.
- Migracao one-shot de token de SharedPreferences para secure storage,
  invocada em `main.dart` (e em `SplashViewmodel`).
- `UserPreferencesService` delega token ao `SecureSessionStorage` via stubs
  (`saveToken` no-op, `getToken` le chave legada apenas para migracao).
- `AuthRemoteDataSourceImp` nao grava mais JSON cru em SharedPreferences.
- `SettingsViewmodel.logout()` agora e `await`-ed e limpa token + chave de
  cache offline + header `Authorization` no Dio.
- Commit: `feat(security): secure session storage and logout hardening`.

Mapeamento desta fase:

- MASVS relacionado: STORAGE-1, STORAGE-2.
- Mobile Top 10 relacionado: M1 Improper Credential Usage, M3 Insecure
  Authentication/Authorization, M9 Insecure Data Storage, M10 Insufficient
  Cryptography.
- Impacto tecnico: token sai do armazenamento chave-valor simples, deixa de ser
  duplicado no JSON de usuario e passa a ser removido de storage/header/cache no
  logout.
- Impacto metodologico no artigo: fornece evidencias quantitativas para reduzir
  M1/M9 de 2 locais inseguros para 0 e sustenta a discussao de defesa em
  profundidade no cliente.

## Fase 3 - AppLogger sanitizado + HandleFailure seguro (commit `cf783a1`)

- Novo `lib/core/logging/app_logger.dart` com niveis (`debug`/`info`/`warn`/`error`)
  e mascaramento de tokens/Authorization (`AppLogger.maskSecret`).
- `http_service_imp.dart` ganha guard `kDebugMode && useDebugLogger`; limpa
  interceptors antes de re-adicionar para nao empilhar loggers entre logins.
- `HandleFailure` default sempre retorna mensagem localizada generica;
  `overrideDefaultMessage` foi removido.
- `TypeFailure` em `experiments_remote_datasource_imp.dart` nao usa mais
  `e.toString()`.
- Timeouts do Dio passam a lancar `NoNetworkFailure` com mensagem curta, sem
  stack.
- `debugPrint` em `home_page.dart` e `calculate_experiment_second_step.dart`
  substituidos por `AppLogger.warn` (compila para no-op em release).
- Commit: `feat(security): sanitized logging and safe error messages`.

Mapeamento desta fase:

- MASVS relacionado: CODE-2, CODE-3.
- Mobile Top 10 relacionado: M1 Improper Credential Usage, M4 Insufficient
  Input/Output Validation, M5 Insecure Communication, M6 Inadequate Privacy
  Controls, M8 Security Misconfiguration.
- Impacto tecnico: logs HTTP e diagnosticos deixam de ser emitidos em release;
  mensagens de erro deixam de expor excecoes/stack/strings brutas.
- Impacto metodologico no artigo: permite medir reducao de logs sensiveis
  ativos em release e melhora a validade das evidencias de privacidade e
  configuracao segura.

## Fase 4 - Validacao local de formularios (commit `bb52aa9`)

- Novo `lib/shared/validator/security_validators.dart` com constantes:
  - Tamanhos: `maxEmailLength = 254` (RFC 5321), `maxPasswordLength = 128`,
    `maxNameLength = 120`, `maxInstitutionLength = 200`,
    `maxDescriptionLength = 2000`, `maxShortTextLength = 250`, `maxVolumeMl = 1000`.
  - Faixas: `minRepetitions/maxRepetitions = 1/100`,
    `minSampleAbsorbance/maxSampleAbsorbance = 0/5`,
    `minDurationHours/maxDurationHours = 0.5/240`,
    `minVariable/maxVariable = -1e6/1e6`,
    `minSizeGrams/maxSizeGrams = 0.001/1000`.
- Helpers: `email()`, `password()`, `requiredName()`, `requiredInstitution()`,
  `requiredShortText()`, `requiredLongText()`, `repetitions()`, `absorbance()`,
  `duration()`, `variableA()`, `sampleSize()`.
- Aplicado em:
  - `login_page.dart`
  - `create_account_first_step.dart` e `create_account_second_step.dart`
  - `create_experiment_first_step.dart`
  - `create_experiment_second_step.dart` (repetitions dentro de `repetitionsRange`)
  - `create_experiment_fourth_step.dart` (intervalos numericos em
    a/b/duration/size)
  - `calculate_experiment_second_step.dart` (limites em sample/whiteSample)
- Commit: `feat(security): form validation hardening`.

Mapeamento desta fase:

- MASVS relacionado: CODE-4.
- Mobile Top 10 relacionado: M4 Insufficient Input/Output Validation, com apoio
  a M3 quando aplicado a login/cadastro.
- Impacto tecnico: formularios criticos passam a ter limites e faixas locais
  consistentes, reduzindo entradas inesperadas antes da chamada ao backend.
- Impacto metodologico no artigo: transforma a validacao local de "parcial" para
  "6/6 formularios criticos" e isola a limitacao de validacao server-side como
  fora do escopo.

## Fase 5 - Rede, ambientes e pinning (stub) (commit `30707e2`)

- `lib/shared/utils/api.dart`: ambientes via `--dart-define=ENV=dev|stage|prod`
  com fallback `prod` quando ausente.
- Novo `lib/core/network/secure_network_config.dart`:
  - `validateBaseUrl(url, env)`: em release para prod exige `https://`
    exceto para entradas em `_legacyCleartextAllowList`.
  - `pinningFor(env)`: hook retornando `CertificatePinningConfig` (stub).
  - `CertificatePinningConfig.spkiHashes: <String>[]` (vazio ate coordenacao
    com backend).
- `main.dart` chama `SecureNetworkConfig.validateBaseUrl(API.apiBaseUrl, env)`
  apos `API.setEnvironment`.
- `android/app/src/main/res/xml/network_security_config.xml`:
  - `base-config` com `cleartextTrafficPermitted="false"` e `trust-anchors`
    somente `system`.
  - `<domain-config>` apenas para `200.133.6.201` (excecao documentada).
  - `<certificates src="user"/>` removido.
- `ios/Runner/Info.plist`: limitacao do ATS (NSA-1) documentada no checklist.
- Commit: `feat(security): HTTPS guard and network config`.

Mapeamento desta fase:

- MASVS relacionado: NETWORK-1, NETWORK-2.
- Mobile Top 10 relacionado: M5 Insecure Communication, M8 Security
  Misconfiguration, M10 Insufficient Cryptography.
- Impacto tecnico: Android passa a negar cleartext por padrao, usar somente
  trust store de sistema e permitir HTTP apenas para o IP legado documentado;
  o app tambem ganha um ponto estavel para pinning futuro.
- Impacto metodologico no artigo: separa mitigacoes sob controle do app
  (guard/config) de dependencias externas (TLS/pinning do backend), importante
  para nao inflar a conclusao experimental.

## Fase 6 - Protecao de interface (commit `97a8c5a`)

- Adicionar `flutter_windowmanager: ^0.2.0` em `pubspec.yaml`.
- Novo `lib/core/platform/screen_protection_service.dart` (wrapper de
  `flutter_windowmanager`/MethodChannel) e
  `lib/core/platform/secure_screen_wrapper.dart` (mixin que chama `enable()` em
  `initState`, `disable()` em `dispose` e overlay branco em `paused`).
- `MainActivity` expoe MethodChannel `enzitech/screen_protection` chamando
  `WindowManager#setFlags(FLAG_SECURE, FLAG_SECURE)` / `clearFlags`.
- Aplicado em:
  - `LoginPage`, `CreateAccountPage`
  - `ExperimentDetailsPage`, `ExperimentResultsPage`, `CalculateExperimentPage`
  - `SettingsPage` (incluido pos-Fase 7, ver abaixo)
- Snackbar revisado: nenhum expoe token/dados de experimento.
- Commit: `feat(security): screen protection on sensitive screens`.

Mapeamento desta fase:

- MASVS relacionado: PLATFORM-9, PLATFORM-10.
- Mobile Top 10 relacionado: M6 Inadequate Privacy Controls, M7 Insufficient
  Binary Protections, M8 Security Misconfiguration.
- Impacto tecnico: telas sensiveis passam a bloquear captura/snapshot no
  Android e exibem overlay em pausa/inatividade.
- Impacto metodologico no artigo: cria a metrica 0/7 -> 7/7 telas sensiveis
  protegidas e evidencia uma limitacao objetiva de plataforma no iOS.

## Fase 7 - Hardening de dependencias e consolidacao (commit `bfce921`)

- Rodar `flutter pub outdated --no-dev-dependencies`; saida registrada em
  `docs/security/security_scenario1_pub_outdated.txt`.
- `pretty_dio_logger` e `curl_logger_dio_interceptor` continuam em runtime
  deps mas so adicionam interceptors com `kDebugMode && useDebugLogger` em
  `http_service_imp.dart`.
- `android/app/build.gradle`: revisar `release { debuggable false }` (ja
  configurado).
- Atualizar colunas "Depois" dos 4 artefatos com valores observados.
- Commit: `docs(security): final metrics and article evidence`.

Mapeamento desta fase:

- MASVS relacionado: DEPENDENCIES e verificacoes consolidadas de CODE/NETWORK.
- Mobile Top 10 relacionado: M2 Inadequate Supply Chain Security, M7
  Insufficient Binary Protections, M8 Security Misconfiguration.
- Impacto tecnico: dependencias diretas ficam inventariadas; loggers HTTP
  permanecem inacessiveis em release; `release { debuggable false }` fica
  registrado como evidencia de build.
- Impacto metodologico no artigo: adiciona rastreabilidade de supply chain e
  build/release sem alterar comportamento funcional do app.

## Correcoes pos-Fase 7

A auditoria final revelou 2 gaps em relacao ao plano declarado. Corrigidos
em um unico patch sem commit dedicado ainda (a fazer):

1. **`SettingsPage` sem `SecureScreenMixin`** - apesar do plano listar a tela
   como sensivel (exibe nome, e-mail, userType e flag de logout), o mixin
   `SecureScreenMixin` nao estava aplicado e o body nao estava envolvido por
   `wrapSecureScreen`. Sem isso a tela permanecia capturavel pela miniatura
   dos recentes e por screenshots.
   Arquivo: `lib/features/main/presentation/ui/pages/settings_fragment/settings_page.dart`.
2. **`debugPrint` em `SecureSessionStorage.migrateFromLegacyIfNeeded`** - a
   mensagem `debugPrint('SecureSessionStorage migration skipped: $e');`
   vazava `e.toString()` da excecao para o logcat mesmo em release. Trocada
   por `AppLogger.warn('SecureSessionStorage migration skipped')`, que
   compila para no-op fora de `kDebugMode`.
   Arquivo: `lib/core/data/service/secure_storage/secure_session_storage.dart`.

Resultado: `dart analyze` em todo o projeto retorna **No issues found!**.

Mapeamento das correcoes pos-Fase 7:

- MASVS relacionado: CODE-2, PLATFORM-9, PLATFORM-10.
- Mobile Top 10 relacionado: M6 Inadequate Privacy Controls, M7 Insufficient
  Binary Protections, M8 Security Misconfiguration.
- Impacto tecnico: elimina uma tela sensivel sem protecao e remove log cru de
  excecao do fluxo de migracao de token.
- Impacto metodologico no artigo: fortalece a consistencia entre plano,
  implementacao e evidencia final, evitando divergencia entre "7/7 telas" e o
  codigo real.

## Extensao Mobile Top 10 2024 - Evidencia incremental (sem commit ainda)

Mudancas desta extensao:

- Adicionar as colunas "OWASP Mobile Top 10 2024" e "Cobertura de risco" ao
  checklist, preservando os controles MASVS.
- Adicionar resumo, metricas por M1-M10 e gap analysis ao documento de metricas.
- Registrar supply chain, segredos hardcoded, configuracoes de ambiente/rede e
  binary protections como evidencias complementares.
- Parametrizar endpoints por build em `lib/shared/utils/api.dart` com
  `DEV_API_BASE_URL`, `STAGE_API_BASE_URL` e `PROD_API_BASE_URL`, preservando
  os fallbacks existentes e o guard HTTPS.
- Padronizar `ScreenProtectionService` para usar `AppLogger.warn` com mensagem
  fixa no lugar de `print(... $e)` em debug.

Mapeamento desta extensao:

- MASVS relacionado: CODE-2, DEPENDENCIES, NETWORK-1, NETWORK-2, PLATFORM-9.
- Mobile Top 10 relacionado: M1, M2, M5, M6, M7, M8, M9, M10.
- Impacto tecnico: 0 novos fluxos funcionais; endpoints podem ser definidos por
  build sem alterar codigo, logs crus permanecem evitados e a evidencia de
  segredos/supply chain/build fica formalizada.
- Impacto metodologico no artigo: permite afirmar que o CENARIO 1 foi
  implementado por MASVS/MASTG e analisado tambem segundo a OWASP Mobile Top 10
  2024, com lacunas explicitamente classificadas.

## Riscos residuais (consolidado)

| Risco | Mitigacao adotada | Trabalho futuro |
|-------|-------------------|-----------------|
| Pinning efetivo | Stub + hook de config | Implementar quando backend emitir certificado fixo |
| Cache offline | Limpeza no logout + chave dedicada | Criptografar com chave derivada do usuario |
| iOS sem FLAG_SECURE nativo | Documentado como limitacao (NSA-1) | Aguardar suporte equivalente |
| ATS iOS | Documentado | Forcar HTTPS no backend de producao |
| `pretty_dio_logger`/`curl_logger_dio_interceptor` em runtime deps | Guard `kDebugMode` | Mover para `dev_dependencies` se a plataforma permitir |
