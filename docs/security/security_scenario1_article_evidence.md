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
  manuais).
- Artefatos produzidos: 4 documentos principais em `docs/security/`:
  - `security_scenario1_checklist.md` (estado por controle MASVS)
  - `security_scenario1_metrics.md` (12 metricas antes/depois)
  - `security_scenario1_changes.md` (diario de mudancas por fase)
  - `security_scenario1_article_evidence.md` (este documento)

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
| M12 | 0 paginas | 4 artefatos | +4 | `docs/security/` pronto para IEEE (~8 paginas) |

## 5. Limitacoes e trabalhos futuros

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

## 6. Referencias

### 6.1 OWASP / Padroes de seguranca

- OWASP Foundation. **Mobile Application Security Verification Standard
  (MASVS) v2.0**. 2023. Disponivel em:
  https://github.com/OWASP/owasp-masvs
- OWASP Foundation. **Mobile Application Security Testing Guide (MASTG) v1.5**.
  2023. Disponivel em: https://github.com/OWASP/owasp-mstg
- OWASP Foundation. **Mobile Top 10 Risks (M1-M10)**. Disponivel em:
  https://owasp.org/www-project-mobile-top-10/
- OWASP Foundation. **MASVS-STORAGE-1 / STORAGE-2**: armazenamento seguro de
  credenciais e dados sensiveis.
- OWASP Foundation. **MASVS-CODE-2 / CODE-3 / CODE-4**: logs, erros e
  validacao de entrada.
- OWASP Foundation. **MASVS-NETWORK-1 / NETWORK-2**: HTTPS e pinning.
- OWASP Foundation. **MASVS-PLATFORM-9 / PLATFORM-10**: protecao de UI e
  FLAG_SECURE.

### 6.2 Plataforma Android

- Google. **Android Security: FLAG_SECURE**. Documentacao oficial.
  https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE
- Google. **Android Network Security Configuration**. Documentacao oficial.
  https://developer.android.com/privacy-and-security/security-config
- Google. **Android Keystore + EncryptedSharedPreferences**. Documentacao
  oficial. https://developer.android.com/topic/security/data

### 6.3 Plataforma iOS

- Apple. **App Transport Security (ATS)**. Documentacao oficial.
  https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity

### 6.4 Flutter / Dart

- Flutter team. **flutter_secure_storage** package. Pub.dev. Documentacao e
  fonte. https://pub.dev/packages/flutter_secure_storage
- Flutter team. **flutter_windowmanager** package. Pub.dev. Documentacao e
  fonte. https://pub.dev/packages/flutter_windowmanager
- Dart team. **dio** HTTP client. Pub.dev. https://pub.dev/packages/dio
- Flutter team. **MethodChannel** (platform channels). Documentacao oficial.
  https://docs.flutter.dev/platform-integration/platform-channels

### 6.5 Citacao sugerida

> Lohans de Melo, A. **Hardening de seguranca mobile baseado em OWASP MASVS:
> estudo de caso no app Enzitech (Flutter)**. Enzitech App, branch
> `OWASP-hardening`, 2026. Artefatos em `docs/security/`.

## 7. Apêndice A - Mapeamento MASVS -> arquivos do projeto

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

## 8. Apêndice B - Lista de commits do hardening

1. `1b3d292` docs(security): baseline CENARIO 1
2. `d9f043f` feat(security): secure session storage and logout hardening
3. `cf783a1` feat(security): sanitized logging and safe error messages
4. `bb52aa9` feat(security): form validation hardening
5. `30707e2` feat(security): HTTPS guard and network config
6. `97a8c5a` feat(security): screen protection on sensitive screens
7. `bfce921` docs(security): final metrics and article evidence
