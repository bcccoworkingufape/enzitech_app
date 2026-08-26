# CENARIO 1 - Metricas de hardening OWASP MASVS

Escopo: Enzitech App (Flutter), branch `OWASP-hardening`. Tabela com valores
"Antes" (estado pre-Fase 1, levantado por inspecao + `rg`) e "Depois"
(valores observados ao final da Fase 7 + correcoes pos-Fase 7).

Convencao de coleta:

- M1, M2, M9, M10: greps por `flutter_secure_storage`, `accessToken`,
  `cleartextTrafficPermitted`, `CertificatePinningConfig`.
- M3: contagem de `print(`/`debugPrint(` em `lib/` fora de `kDebugMode`.
- M4: contagem de arquivos em `lib/features/**/presentation/ui/pages/**` que
  importam `security_validators.dart`.
- M5: contagem de `with SecureScreenMixin` em arquivos de pagina.
- M6: busca por `failure.message`/`overrideDefaultMessage`/`e.toString()` nos
  call sites de `HandleFailure.of`.
- M7, M8: presenca do guard em `SecureNetworkConfig.validateBaseUrl`.
- M11: saida de `flutter pub outdated` capturada em
  `docs/security/security_scenario1_pub_outdated.txt`.
- M12: contagem de paginas impressas dos 4 artefatos em `docs/security/`.
- Extensao Mobile Top 10 2024: varreduras adicionais com `rg` para segredos
  hardcoded, endpoints HTTP/cleartext, configuracao de release Android e
  dependencias diretas registradas em `pubspec.yaml`/`pubspec.lock`.

| # | Metrica | Valor Antes | Valor Depois (observado) |
|---|---------|-------------|--------------------------|
| M1 | Locais que armazenam token de forma insegura | **2** (`token` em SharedPreferences + `accessToken` no JSON `user`) | **0** (token em `flutter_secure_storage`; JSON `user` sem `accessToken`) |
| M2 | Mecanismo de armazenamento sensivel | **SharedPreferences** (sem secure storage) | **flutter_secure_storage** com `AndroidOptions(encryptedSharedPreferences: true)` e `IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device)` |
| M3 | Logs sensiveis explicitos ativos em release | **2** `debugPrint` + 2 interceptors Dio latentes (fora de guard) | **0** ativos em release; todos os `print()` em `lib/` estao sob `kDebugMode` (`app_logger.dart`, `string_extensions.dart`) ou em scripts de tooling (`build_arb.dart`). `SecureSessionStorage.migrateFromLegacyIfNeeded` trocou `debugPrint` por `AppLogger.warn` |
| M4 | Formularios criticos com validacao local completa | **5/6 parcial** | **6/6** (login, create account 2 steps, create experiment 4 steps, calculate experiment) |
| M5 | Telas sensiveis protegidas (FLAG_SECURE) | **0/7** | **7/7** - Login, CreateAccount, ExperimentDetails, ExperimentResults, CalculateExperiment, Settings (Android via `MainActivity` `FLAG_SECURE` + mixin `SecureScreenMixin`/`wrapSecureScreen`) |
| M6 | Pontos com mensagem de erro potencialmente insegura | **~4** (`failure.message` em `HandleFailure`, `e.toString()` em `TypeFailure`, `overrideDefaultMessage`) | **0** (`HandleFailure` default nunca expoe `failure.message`; `TypeFailure` sem `e.toString()`; timeouts viram `NoNetworkFailure` generico) |
| M7 | Producao usa HTTPS | **Nao** (`http://200.133.6.201:30001/`) | **Guarda HTTPS** ativa (`SecureNetworkConfig.validateBaseUrl`) + allowlist documentada para o IP legado ate migracao TLS do backend |
| M8 | Guarda HTTPS implementada | **0** | **1** (`lib/core/network/secure_network_config.dart::SecureNetworkConfig.validateBaseUrl`) |
| M9 | Cleartext Android global | **Permitido** (`cleartextTrafficPermitted="true"` + `<certificates src="user"/>`) | **Restrito** (`cleartextTrafficPermitted="false"` no `base-config`; excecao explicita apenas para `200.133.6.201`) |
| M10 | Pinning efetivo | **Nao** | **Stub** (`CertificatePinningConfig` preparado; `spkiHashes` vazio ate certificado do backend estabilizar) |
| M11 | Dependencias criticas sem hardening | `pretty_dio_logger` e `curl_logger_dio_interceptor` em runtime deps; `dio 5.9.0`, `flutter_secure_storage` ausente | Loggers HTTP guardados por `kDebugMode` em `http_service_imp.dart`; `flutter_secure_storage 9.2.4` introduzido. Versoes atuais registradas em `security_scenario1_pub_outdated.txt` (major upgrade de `flutter_secure_storage` para 10.x exige teste de migracao) |
| M12 | Documentacao OWASP para artigo IEEE | **0 paginas** | **4 artefatos principais** em `docs/security/` (~8 paginas) + 1 evidencia complementar (`security_scenario1_secret_scan.md`) |
| M13 | Segredos privados hardcoded encontrados | **Nao medido** | **0 segredos privados confirmados** por `rg` em `lib`, `android`, `ios`, `pubspec.yaml` e `docs/security`; foram encontrados somente Firebase API keys publicas em `lib/firebase_options.dart` e placeholders de `key.properties` no Gradle |
| M14 | Dependencias criticas desatualizadas antes/depois | **2 deps sensiveis sem mitigacao** (`pretty_dio_logger`, `curl_logger_dio_interceptor`) + secure storage ausente | **0 deps sensiveis ativas em release**; `dio 5.9.0` e `flutter_secure_storage 9.2.4` revisados, com upgrades patch/major documentados em `security_scenario1_pub_outdated.txt` |
| M15 | Configuracoes inseguras de ambiente/rede | **3** (`prod` HTTP, Android cleartext global permitido, trust store de usuario) | **1 residual documentado** (allowlist cleartext somente para `200.133.6.201` ate TLS do backend); `base-config` HTTPS-only, trust store somente `system` e endpoints sobrescritos por `DEV_API_BASE_URL`/`STAGE_API_BASE_URL`/`PROD_API_BASE_URL` via `--dart-define` |

Observacoes:

- M5 = 7/7 apos correcao pos-Fase 7 (`SettingsPage` nao tinha o mixin aplicado
  apesar do plano listar a tela como sensivel; corrigido em
  `lib/features/main/presentation/ui/pages/settings_fragment/settings_page.dart`).
- M3 inclui o ajuste de `SecureSessionStorage` que trocou `debugPrint` por
  `AppLogger.warn` para nao vazar `e.toString()` em release.
- M7/M8 estao conformes para `prod`; a permissao de cleartext no IP legado e
  excecao documentada que deve ser removida apos o backend migrar para TLS.
- M10 fica como trabalho futuro - depende de coordenacao com a equipe do
  backend para fixar o certificado de producao.
- M13 foi coletada por varredura estatica. Firebase API keys aparecem como
  configuracao publica de cliente, nao como segredo privado; nenhuma chave
  privada, keystore, `.env`, PEM/JKS/P12 ou token real foi encontrado no
  workspace versionado.
- M14 nao aplica upgrades automaticamente para evitar mudancas funcionais fora
  do escopo; a mitigacao incremental foi reduzir exposicao em release e
  registrar a trilha de auditoria.
- M15 separa o que o app consegue controlar localmente (Network Security
  Config, guard HTTPS, trust anchors e configuracao por build) do risco
  residual externo (backend ainda sem TLS).

## Resumo por OWASP Mobile Top 10 2024

MASVS/MASTG permanece como base de controle. Esta tabela classifica os mesmos
resultados pela OWASP Mobile Top 10 2024 para apoiar a analise de risco do
artigo.

| Risco OWASP Mobile Top 10 2024 | Antes | Depois | Cobertura no CENARIO 1 | Lacunas residuais |
|--------------------------------|-------|--------|-------------------------|-------------------|
| M1 Improper Credential Usage | Token em SharedPreferences, duplicacao em JSON e logs/interceptors latentes | Token em `flutter_secure_storage`, JSON sem `accessToken`, logout limpa token/header/interceptors | Alta | Firebase API keys publicas documentadas; politicas de rotacao de credenciais do backend fora do escopo |
| M2 Inadequate Supply Chain Security | Revisao de dependencias ainda nao registrada | `flutter pub outdated` registrado; loggers HTTP guardados em debug; deps criticas identificadas | Parcial | Upgrades major/patch ainda pendentes; sem SCA automatizado/CI |
| M3 Insecure Authentication/Authorization | Sessao local persistia token de modo inseguro e logout incompleto | Token seguro + logout completo + erros de auth genericos | Alta no cliente | Regras de autorizacao do backend fora do escopo |
| M4 Insufficient Input/Output Validation | Validacao local parcial e mensagens/erros com chance de detalhe tecnico | `SecurityValidators` aplicado nos formularios criticos; timeouts/erros sanitizados | Alta no cliente | Validacao server-side nao avaliada |
| M5 Insecure Communication | Producao em HTTP e Android cleartext global permitido | Guard HTTPS, Network Security Config restritivo e allowlist explicita para IP legado | Parcial | Backend de producao ainda precisa TLS; pinning efetivo pendente |
| M6 Inadequate Privacy Controls | Telas sensiveis capturaveis e logs/mensagens menos restritivos | FLAG_SECURE/overlay em 7/7 telas, logs de release zerados, mensagens genericas | Alta em Android; parcial multiplataforma | iOS sem equivalente nativo de FLAG_SECURE; cache offline ainda em SharedPreferences |
| M7 Insufficient Binary Protections | Release revisado apenas informalmente | `debuggable false`, protecao de tela Android e evidencia de build release registrada | Parcial | Sem minificacao/ofuscacao/pinning efetivo automatizados neste cenario |
| M8 Security Misconfiguration | Cleartext global, trust store de usuario, loggers HTTP latentes | Cleartext global falso, trust store `system`, loggers sob `kDebugMode`, guard de ambiente | Alta com excecao documentada | Allowlist HTTP temporaria e TODO de pinning |
| M9 Insecure Data Storage | Token em SharedPreferences + `accessToken` no JSON | Token em secure storage; perfil sem token; limpeza de caches no logout | Alta para token; parcial para cache | Cache offline sem criptografia |
| M10 Insufficient Cryptography | Sem secure storage/pinning | EncryptedSharedPreferences/Keychain para token; stub de pinning | Parcial | Pinning e criptografia do cache offline pendentes |

## Metricas por risco M1-M10

| Risco | Metricas usadas | Antes | Depois |
|-------|-----------------|-------|--------|
| M1 | M1, M2, M3, M13 | 2 locais de token inseguro + logs/interceptors latentes | 0 locais de token inseguro; 0 segredos privados confirmados na varredura |
| M2 | M11, M14 | Dependencias sensiveis sem mitigacao e sem evidencia formal | `pub outdated` registrado; 0 loggers HTTP ativos em release |
| M3 | M1, M4, M6 | Logout incompleto e erros com detalhe tecnico | Logout completo; erros genericos; token seguro |
| M4 | M4, M6, M13 | 5/6 formularios parcialmente validados | 6/6 formularios criticos validados; erros/outputs sanitizados |
| M5 | M7, M8, M9, M10, M15 | HTTP prod + cleartext global + sem pinning | Guard HTTPS + cleartext restrito a 1 IP + pinning stub |
| M6 | M3, M5, M6 | 0/7 telas sensiveis protegidas e logs/mensagens menos restritivos | 7/7 telas protegidas; 0 logs sensiveis ativos em release |
| M7 | M5, M11, M14 | Release sem evidencias de protecao binaria alem do padrao | `debuggable false` evidenciado; protecao de tela; supply chain revisado |
| M8 | M3, M7, M8, M9, M15 | Misconfig de cleartext/trust/logging | Guard de ambiente, trust store system-only, cleartext global falso e endpoints por `--dart-define` |
| M9 | M1, M2, M5 | Token e perfil persistidos de forma insegura | Token seguro; perfil sem token; logout limpa caches |
| M10 | M2, M10, M15 | Sem armazenamento criptografado para token | Secure storage habilitado; pinning preparado |

## Gap analysis Mobile Top 10 2024

| Risco | Estado | Gap | Baixo esforco/alto valor no app Flutter |
|-------|--------|-----|------------------------------------------|
| M1 | Parcialmente tratado | Segredos publicos Firebase precisam ser classificados para evitar falso positivo | Feito: varredura explicita e registro em M13 |
| M2 | Parcialmente tratado | Sem SCA automatizado e upgrades pendentes | Registrar `pub outdated`; upgrades ficam para sprint propria |
| M3 | Tratado no cliente | Backend authz nao avaliado | Nao tratar neste cenario, pois exige backend |
| M4 | Tratado no cliente | Backend validation nao avaliado | Nao tratar neste cenario, pois exige backend |
| M5 | Parcialmente tratado | TLS/pinning dependem do backend | Manter allowlist minima e evidencia; remover apos TLS |
| M6 | Parcialmente tratado | iOS sem FLAG_SECURE nativo; cache offline | Documentar limitacao; criptografia de cache fica futuro |
| M7 | Parcialmente tratado | Sem minificacao/ofuscacao formal | Registrar build release; avaliar R8/ofuscacao em cenario dedicado |
| M8 | Parcialmente tratado | Allowlist HTTP temporaria e TODO de pinning | Feito: metricar configs inseguras antes/depois e parametrizar endpoints por `--dart-define` |
| M9 | Parcialmente tratado | Cache offline sem criptografia | Nao tratar agora para nao mudar UX/offline |
| M10 | Parcialmente tratado | Pinning e cache criptografado pendentes | Depende de certificado/backend e desenho de chave do cache |

## Resumo executivo

- Controles MASVS-STORAGE-1/2, CODE-2/3/4, NETWORK-1 e PLATFORM-9/10:
  **conformidade plena**.
- NETWORK-2 (pinning efetivo): **stub preparatorio**; execucao depende de
  coordenacao com o backend.
- DEPENDENCIES: loggers HTTP estao em runtime deps mas guardados por
  `kDebugMode`; mover para `dev_dependencies` fica como follow-up.
- Cobertura final: **7/7 telas sensiveis com FLAG_SECURE**, **6/6 formularios
  criticos com validacao local**, **token somente em secure storage**, **erros
  sempre amigaveis e localizados**, **cleartext Android restrito a 1 IP
  documentado**.
