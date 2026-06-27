# CENARIO 1 - Evidencia metodologica para artigo IEEE

Este documento registra a linha metodologica do estudo de caso aplicado ao app Enzitech.
Segue o roteiro: baseline (Fase 1) -> intervencao incremental (Fases 2-7) -> metricas
de impacto -> limitacoes e trabalhos futuros.

## 1. Contexto

- Aplicacao: Enzitech App (Flutter, clean architecture leve).
- Backend: API REST ja em producao (`http://200.133.6.201:30001/` - fora do escopo do
  hardening manter HTTP no curto prazo).
- Framework de seguranca: OWASP MASVS v2.0 com mapeamento para MASTG (testes manuais).
- Artefatos produzidos: 4 documentos principais em `docs/security/`:
  - `security_scenario1_checklist.md` (estado por controle MASVS).
  - `security_scenario1_metrics.md` (12 metricas antes/depois).
  - `security_scenario1_changes.md` (diario de mudancas por fase).
  - `security_scenario1_article_evidence.md` (este documento).

## 2. Metodologia

1. **Baseline qualitativo e quantitativo** (Fase 1):
   inventario estatico do codigo + busca de sentinelas com `rg`.
   Tabulamos 12 metricas M1..M12, com fonte de evidencia e metodo de coleta.
2. **Intervencao incremental**: 6 fases (2-7) em formato de commits atomicos.
   Cada fase preserva build e nao refatora arquitetura.
3. **Re-medicao** (Fase 7): mesmas 12 metricas com novos valores.
4. **Analise qualitativa**: cruzar metricas com checklist MASVS para indicar
   controles ainda nao conformes (e justificativa: fora de escopo, trade-off,
   limitacao de plataforma).

## 3. Resumo das intervencoes

| Fase | Tema MASVS | Codigo introduzido | Documentos afetados |
|------|-----------|--------------------|---------------------|
| 2 | STORAGE | `SecureSessionStorage`, migracao de token | checklist, metricas (M1, M2) |
| 3 | CODE | `AppLogger`, `HandleFailure` seguro | checklist, metricas (M3, M6) |
| 4 | CODE | `security_validators.dart` | checklist, metricas (M4) |
| 5 | NETWORK | `SecureNetworkConfig`, ajustes Android | checklist, metricas (M7, M8, M9, M10) |
| 6 | PLATFORM | `SecureScreenWrapper`, FLAG_SECURE | checklist, metricas (M5) |
| 7 | DEPS + DOCS | `pub outdated`, consolidacao | metricas (M11, M12) |

## 4. Resultados (placeholders ate a Fase 7)

Preencher ao final:

| Metrica | Antes | Depois | Delta | Observacao |
|---------|-------|--------|-------|------------|
| M1 | 2 | a preencher | a preencher | Token removido de SharedPreferences |
| M2 | SharedPrefs | a preencher | a preencher | flutter_secure_storage ativo |
| M3 | 2 debugPrint | a preencher | a preencher | Removidos/guardados |
| M4 | 5/6 parcial | a preencher | a preencher | 6/6 |
| M5 | 0/7 | a preencher | a preencher | FLAG_SECURE aplicado |
| M6 | ~4 | a preencher | a preencher | Erros genericos |
| M7 | HTTP | a preencher | a preencher | Guarda HTTPS + allowlist |
| M8 | Nao | a preencher | a preencher | 1 guarda |
| M9 | Permitido | a preencher | a preencher | Cleartext restrito a 1 dominio |
| M10 | Nao | a preencher | a preencher | Stub preparatorio |
| M11 | 2 deps sensiveis | a preencher | a preencher | Guard kDebugMode |
| M12 | 0 paginas | a preencher | a preencher | >=6 paginas de evidencia |

## 5. Limitacoes e trabalhos futuros

- Pinning efetivo depende de certificado do backend.
- Cache offline segue sem criptografia (trade-off de UX); limpeza no logout.
- iOS: sem FLAG_SECURE nativo - apenas documentado (NSA-1).
- Validacao local nao substitui validacao no backend; ambas sao necessarias.
- Estudo de caso single-app: generalizacao exige replicacao em outros dominios.

## 6. Citacao sugerida

> Lohans de Melo, A. *Hardening de seguranca mobile baseado em OWASP MASVS: estudo
> de caso no app Enzitech (Flutter)*. Enzitech App, branch `OWASP-hardening`,
> 2026. Artefatos em `docs/security/`.
