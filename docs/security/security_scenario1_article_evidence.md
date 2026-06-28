# CENARIO 1 - Evidencia metodologica para artigo IEEE

Este documento registra a linha metodologica do estudo de caso aplicado ao
app Enzitech. Segue o roteiro: baseline (Fase 1) -> intervencao incremental
(Fases 2-7) -> correcoes pos-Fase 7 -> metricas de impacto -> limitacoes e
trabalhos futuros. Foi desenhado para servir como secao de "Methodology" e
"Results" de um manuscrito IEEE.

## 1. Contexto

- Aplicacao: Enzitech App (Flutter, clean architecture leve, MVC+MVVM).
- Backend: API REST em producao (`http://200.133.6.201:30001/`, fora do escopo
  do hardening; migracao TLS pendente).
- Framework de seguranca: OWASP MASVS v2.0 com mapeamento para MASTG (testes
  manuais). A OWASP Mobile Top 10 2024 e adicionada como camada complementar
  de classificacao de risco, sem substituir os controles MASVS/MASTG.
- Artefatos produzidos: 4 documentos principais em `docs/security/` e 1
  evidencia complementar:
  - `security_scenario1_checklist.md` (estado por controle MASVS)
  - `security_scenario1_metrics.md` (15 metricas antes/depois apos extensao)
  - `security_scenario1_changes.md` (diario de mudancas por fase)
  - `security_scenario1_article_evidence.md` (este documento)
  - `security_scenario1_secret_scan.md` (evidencia complementar de segredos)

## 2. Metodologia

1. **Baseline qualitativo e quantitativo** (Fase 1):
   inventario estatico do codigo + busca de sentinelas com `rg`.
   Tabulamos 12 metricas M1..M12, com fonte de evidencia e metodo de coleta
   descritos em `security_scenario1_metrics.md`.
2. **Intervencao incremental**: 6 fases (2-7) em formato de commits atomicos
   (1b3d292, d9f043f, cf783a1, bb52aa9, 30707e2, 97a8c5a, bfce921).
   Cada fase preserva build e nao refatora arquitetura.
3. **Auditoria final + correcoes pos-Fase 7**:
   re-leitura dos artefatos contra o codigo atual revelou dois gaps
   (Settings sem mixin e `debugPrint` em `SecureSessionStorage`) que foram
   corrigidos com `dart analyze` limpo.
4. **Re-medicao** (Fase 7 + pos-Fase 7): mesmas 12 metricas com novos
   valores observados.
5. **Analise qualitativa**: cruzar metricas com checklist MASVS para indicar
   controles ainda nao conformes (e justificativa: fora de escopo, trade-off
   ou limitacao de plataforma).
6. **Classificacao Mobile Top 10 2024**: mapear cada fase e metrica para
   M1-M10, registrando lacunas residuais e distinguindo mitigacoes locais do
   app de dependencias externas como TLS/pinning/backend.

## 3. Resumo das intervencoes

| Fase | Tema MASVS | Codigo introduzido | Documentos afetados |
|------|-----------|--------------------|---------------------|
| 2 | STORAGE | `SecureSessionStorage`, migracao de token | checklist, metricas (M1, M2) |
| 3 | CODE | `AppLogger`, `HandleFailure` seguro | checklist, metricas (M3, M6) |
| 4 | CODE | `security_validators.dart` | checklist, metricas (M4) |
| 5 | NETWORK | `SecureNetworkConfig`, ajustes Android | checklist, metricas (M7, M8, M9, M10) |
| 6 | PLATFORM | `SecureScreenWrapper`, FLAG_SECURE | checklist, metricas (M5) |
| 7 | DEPS + DOCS | `pub outdated`, consolidacao | metricas (M11, M12) |
| pos-7 | Correcoes | `SettingsPage` mixin + `AppLogger.warn` em `SecureSessionStorage` | checklist, metricas (M3, M5) |
| extensao MT10 | Risco + evidencias | mapeamento Mobile Top 10 2024 + `AppLogger.warn` em `ScreenProtectionService` | checklist, metricas, changes, article evidence |

## 4. Resultados (valores observados)

| Metrica | Antes | Depois | Delta | Observacao |
|---------|-------|--------|-------|------------|
| M1 | 2 | 0 | -2 | Token removido de SharedPreferences e JSON persistido |
| M2 | SharedPrefs | flutter_secure_storage | troca | EncryptedSharedPreferences + Keychain ativos |
| M3 | 2 debugPrint + 2 interceptors latentes | 0 ativos em release | -4 | AppLogger + kDebugMode; `SecureSessionStorage` substituiu `debugPrint` por `AppLogger.warn` |
| M4 | 5/6 parcial | 6/6 | +1/6 | SecurityValidators aplicado em login, create account 2 steps, create experiment 3 steps, calculate experiment |
| M5 | 0/7 | 7/7 | +7 | FLAG_SECURE + overlay; Settings incluido na correcao pos-Fase 7 |
| M6 | ~4 | 0 | -4 | Erros genericos; timeouts viram `NoNetworkFailure` |
| M7 | HTTP | Guarda HTTPS + allowlist | -1 (risco) | TLS backend pendente |
| M8 | 0 | 1 | +1 | `validateBaseUrl` ativo |
| M9 | Permitido | Restrito | -1 (risco) | Cleartext desligado global; excecao explicita para IP prod |
| M10 | 0 | Stub | +1 | Hook preparatorio |
| M11 | 2 deps sensiveis | Guard kDebugMode | -2 (risco) | Auditadas via `flutter pub outdated` |
| M12 | 0 paginas | 4 artefatos principais | +4 | `docs/security/` pronto para IEEE (~8 paginas) + 1 evidencia complementar |
| M13 | Nao medido | 0 segredos privados confirmados | evidencia nova | Firebase API keys publicas classificadas; nenhum `.env`, keystore, PEM/JKS/P12 ou token real encontrado |
| M14 | 2 deps sensiveis sem mitigacao + secure storage ausente | 0 loggers HTTP ativos em release + secure storage presente | -2 riscos ativos | Upgrades permanecem documentados, nao aplicados automaticamente |
| M15 | 3 configs inseguras | 1 residual documentado | -2 | HTTP prod residual isolado em allowlist ate TLS do backend |

## 5. Evidencias complementares Mobile Top 10 2024

### 5.1 Evidencia de supply chain

- Fonte: `pubspec.yaml`, `pubspec.lock` e
  `docs/security/security_scenario1_pub_outdated.txt`.
- Riscos Mobile Top 10: M2 Inadequate Supply Chain Security, M7 Insufficient
  Binary Protections, M8 Security Misconfiguration.
- Resultado antes: `pretty_dio_logger` e `curl_logger_dio_interceptor` eram
  dependencias runtime com potencial de expor trafego; `flutter_secure_storage`
  ainda nao compunha a estrategia de sessao.
- Resultado depois: loggers HTTP continuam inventariados, mas sao ativados
  somente em `kDebugMode && useDebugLogger`; `flutter_secure_storage 9.2.4`
  foi introduzido para credenciais; upgrades patch/major ficam registrados para
  uma intervencao de compatibilidade propria.
- Lacuna: nao ha SCA automatizado em CI nem atualizacao major aplicada neste
  cenario, para evitar quebra funcional fora do objetivo incremental.

### 5.2 Evidencia de segredos hardcoded

- Fonte: varredura com `rg` por termos como `apiKey`, `secret`, `password`,
  `token`, `authorization`, `bearer`, `client_secret`, `private_key`, `dsn`,
  alem de busca por arquivos `.env`, `key.properties`, keystores e PEM/JKS/P12.
- Riscos Mobile Top 10: M1 Improper Credential Usage, M2 Inadequate Supply
  Chain Security, M8 Security Misconfiguration, M9 Insecure Data Storage.
- Resultado: 0 segredos privados confirmados em arquivos versionados. O achado
  de `lib/firebase_options.dart` corresponde a API keys publicas de cliente
  Firebase, que identificam o projeto mas nao devem ser tratadas como segredo
  de autenticacao. `android/app/build.gradle` referencia `key.properties`, mas
  o arquivo de propriedades/chaves nao foi encontrado no workspace versionado.
- Acao incremental: registrar explicitamente a evidencia em metricas e no
  checklist, evitando falso positivo metodologico.

### 5.3 Evidencia de binary protections / build release

- Fonte: `android/app/build.gradle`, `android/app/src/main/AndroidManifest.xml`,
  `android/app/src/main/res/xml/network_security_config.xml`,
  `MainActivity.kt` e `SecureScreenWrapper`.
- Riscos Mobile Top 10: M7 Insufficient Binary Protections, M8 Security
  Misconfiguration e M6 Inadequate Privacy Controls.
- Resultado antes: build release nao tinha evidencia consolidada no artigo;
  Android aceitava cleartext global e trust anchors de usuario.
- Resultado depois: `release { debuggable false }` esta documentado;
  `networkSecurityConfig` aplica `cleartextTrafficPermitted="false"` por padrao;
  trust anchors usam somente `system`; `FLAG_SECURE` protege 7/7 telas sensiveis
  no Android.
- Lacuna: minificacao/ofuscacao/R8 e pinning efetivo nao foram ativados neste
  cenario porque podem exigir testes de regressao e coordenacao com backend.

## 6. Limitacoes e trabalhos futuros

- **Pinning efetivo** depende de coordenacao com o backend para fixar o
  certificado de producao. Apos isso, preencher `spkiHashes` em
  `CertificatePinningConfig.forEnvironment` por ambiente.
- **Cache offline** segue sem criptografia (trade-off de UX); limpeza
  garantida no logout. Trabalho futuro: derivar chave do usuario para
  criptografar `experiments_cache`, `treatments_cache` e `enzymes_cache`.
- **iOS**: sem FLAG_SECURE nativo - apenas documentado (NSA-1).
- **Validacao local** nao substitui validacao no backend; ambas sao
  necessarias (defense in depth).
- **Estudo de caso single-app**: generalizacao exige replicacao em outros
  dominios (financas, saude, IoT).
- **Loggers HTTP em runtime deps**: mover `pretty_dio_logger` e
  `curl_logger_dio_interceptor` para `dev_dependencies` se a plataforma
  permitir.

## 7. Referencias

### 7.1 OWASP / Padroes de seguranca

- OWASP Foundation. **Mobile Application Security Verification Standard
  (MASVS) v2.0**. 2023. Disponivel em:
  https://github.com/OWASP/owasp-masvs
- OWASP Foundation. **Mobile Application Security Testing Guide (MASTG) v1.5**.
  2023. Disponivel em: https://github.com/OWASP/owasp-mstg
- OWASP Foundation. **Mobile Top 10 Risks (M1-M10)**. Disponivel em:
  https://owasp.org/www-project-mobile-top-10/
- OWASP Foundation. **Mobile Top 10 2024**: M1 Improper Credential Usage, M2
  Inadequate Supply Chain Security, M3 Insecure Authentication/Authorization,
  M4 Insufficient Input/Output Validation, M5 Insecure Communication, M6
  Inadequate Privacy Controls, M7 Insufficient Binary Protections, M8 Security
  Misconfiguration, M9 Insecure Data Storage, M10 Insufficient Cryptography.
- OWASP Foundation. **MASVS-STORAGE-1 / STORAGE-2**: armazenamento seguro de
  credenciais e dados sensiveis.
- OWASP Foundation. **MASVS-CODE-2 / CODE-3 / CODE-4**: logs, erros e
  validacao de entrada.
- OWASP Foundation. **MASVS-NETWORK-1 / NETWORK-2**: HTTPS e pinning.
- OWASP Foundation. **MASVS-PLATFORM-9 / PLATFORM-10**: protecao de UI e
  FLAG_SECURE.

### 7.2 Plataforma Android

- Google. **Android Security: FLAG_SECURE**. Documentacao oficial.
  https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE
- Google. **Android Network Security Configuration**. Documentacao oficial.
  https://developer.android.com/privacy-and-security/security-config
- Google. **Android Keystore + EncryptedSharedPreferences**. Documentacao
  oficial. https://developer.android.com/topic/security/data

### 7.3 Plataforma iOS

- Apple. **App Transport Security (ATS)**. Documentacao oficial.
  https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity

### 7.4 Flutter / Dart

- Flutter team. **flutter_secure_storage** package. Pub.dev. Documentacao e
  fonte. https://pub.dev/packages/flutter_secure_storage
- Flutter team. **flutter_windowmanager** package. Pub.dev. Documentacao e
  fonte. https://pub.dev/packages/flutter_windowmanager
- Dart team. **dio** HTTP client. Pub.dev. https://pub.dev/packages/dio
- Flutter team. **MethodChannel** (platform channels). Documentacao oficial.
  https://docs.flutter.dev/platform-integration/platform-channels

### 7.5 Citacao sugerida

> Lohans de Melo, A. **Hardening de seguranca mobile baseado em OWASP MASVS:
> estudo de caso no app Enzitech (Flutter)**. Enzitech App, branch
> `OWASP-hardening`, 2026. Artefatos em `docs/security/`.

## 8. Apêndice A - Mapeamento MASVS -> arquivos do projeto

| Controle | Arquivos principais |
|----------|---------------------|
| STORAGE-1 | `lib/core/data/service/secure_storage/secure_session_storage.dart`, `lib/core/data/service/user_preferences/user_preferences_service_imp.dart` |
| STORAGE-2 | mesmos + `lib/features/main/data/datasources/local/user_preferences_local_datasource_imp.dart` |
| CODE-2 | `lib/core/logging/app_logger.dart`, `lib/core/data/service/http/http_service_imp.dart` |
| CODE-3 | `lib/core/failures/handle_failures.dart`, `lib/core/failures/general_failures/type_failure.dart` |
| CODE-4 | `lib/shared/validator/security_validators.dart` + 7 paginas com formularios |
| NETWORK-1 | `lib/core/network/secure_network_config.dart`, `android/app/src/main/res/xml/network_security_config.xml` |
| NETWORK-2 | `lib/core/network/secure_network_config.dart` (stub) |
| PLATFORM-9/10 | `android/app/src/main/kotlin/com/lohhans/enzitech/MainActivity.kt`, `lib/core/platform/screen_protection_service.dart`, `lib/core/platform/secure_screen_wrapper.dart` |

## 9. Apêndice B - Lista de commits do hardening

1. `1b3d292` docs(security): baseline CENARIO 1
2. `d9f043f` feat(security): secure session storage and logout hardening
3. `cf783a1` feat(security): sanitized logging and safe error messages
4. `bb52aa9` feat(security): form validation hardening
5. `30707e2` feat(security): HTTPS guard and network config
6. `97a8c5a` feat(security): screen protection on sensitive screens
7. `bfce921` docs(security): final metrics and article evidence

## 10. Síntese do CENÁRIO 1 segundo a OWASP Mobile Top 10 2024

O CENARIO 1 pode ser descrito metodologicamente como uma intervencao baseada em
OWASP MASVS/MASTG, com classificacao complementar pela OWASP Mobile Top 10
2024. A tabela abaixo organiza as evidencias por risco M1-M10.

| Risco | Evidencias implementadas no CENARIO 1 | Cobertura | Lacunas / trabalho futuro |
|-------|---------------------------------------|-----------|---------------------------|
| M1 Improper Credential Usage | Token migrado para `flutter_secure_storage`; JSON de usuario sem `accessToken`; logout remove token/header/interceptors; varredura de segredos hardcoded registrada | Alta | Politicas de rotacao e credenciais do backend fora do escopo |
| M2 Inadequate Supply Chain Security | `flutter pub outdated` registrado; dependencias sensiveis identificadas; loggers HTTP inativos em release | Parcial | SCA automatizado e upgrades major/patch em cenario separado |
| M3 Insecure Authentication/Authorization | Sessao local protegida; logout completo; erros de autenticacao genericos | Alta no app | Autorizacao backend nao avaliada |
| M4 Insufficient Input/Output Validation | `SecurityValidators` aplicado nos formularios criticos; erros/outputs sanitizados | Alta no app | Validacao backend nao avaliada |
| M5 Insecure Communication | Guard HTTPS em release/prod; Android cleartext negado por padrao; excecao unica para IP legado; pinning stub | Parcial | TLS do backend e pins SPKI reais pendentes |
| M6 Inadequate Privacy Controls | FLAG_SECURE/overlay em 7/7 telas sensiveis; logs e mensagens reduzidos; snackbars sem token/dados de experimento | Alta em Android | iOS sem equivalente nativo; cache offline ainda sem criptografia |
| M7 Insufficient Binary Protections | `debuggable false` documentado; protecao de tela Android; build release revisado | Parcial | Minificacao/ofuscacao/R8 e anti-tamper fora deste cenario |
| M8 Security Misconfiguration | Network Security Config restritivo; trust store somente `system`; loggers sob `kDebugMode`; ambiente validado por `SecureNetworkConfig` | Alta com excecao documentada | Allowlist HTTP temporaria e TODO de pinning |
| M9 Insecure Data Storage | Token fora de SharedPreferences; perfil sem token; caches removidos no logout | Alta para credencial, parcial para cache | Criptografia do cache offline |
| M10 Insufficient Cryptography | EncryptedSharedPreferences/Keychain para token; hook de pinning criado | Parcial | Pinning efetivo e criptografia do cache dependem de desenho adicional |

Conclusao para o artigo: o CENARIO 1 nao substitui MASVS/MASTG pela Mobile Top
10. Ele usa MASVS/MASTG como matriz de implementacao e verificacao, e usa a
OWASP Mobile Top 10 2024 para classificar os riscos mitigados, parcialmente
mitigados e residuais.
