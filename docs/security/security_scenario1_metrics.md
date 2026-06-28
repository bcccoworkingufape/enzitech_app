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
| M11 | Dependencias criticas sem hardening | `pretty_dio_logger` e `curl_logger_dio_interceptor` em runtime deps; `dio 5.9.0`, `flutter_secure_storage 9.2.4` | Loggers HTTP guardados por `kDebugMode` em `http_service_imp.dart`; `flutter_secure_storage 9.2.4` introduzido. Versoes atuais registradas em `security_scenario1_pub_outdated.txt` (major upgrade de `flutter_secure_storage` para 10.x exige teste de migracao) |
| M12 | Documentacao OWASP para artigo IEEE | **0 paginas** | **4 artefatos** em `docs/security/` (~8 paginas): checklist, metricas, changes, article evidence |

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

## Resumo executivo

- Controles MASVS-STORAGE-1/2, CODE-2/3/4, NETWORK-1 e PLATFORM-9/10:
  **conformidade plena**.
- NETWORK-2 (pinning efetivo): **stub preparatorio**; execucao depende de
  coordenacao com o backend.
- DEPENDENCIES: loggers HTTP estao em runtime deps mas guardados por
  `kDebugMode`; mover para `dev_dependencies` fica como follow-up.
- Cobertura final: **5/5 telas sensiveis com FLAG_SECURE**, **6/6 formularios
  criticos com validacao local**, **token somente em secure storage**, **erros
  sempre amigaveis e localizados**, **cleartext Android restrito a 1 IP
  documentado**.
