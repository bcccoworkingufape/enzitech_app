# Technical debt and risks

Prioridades são relativas ao Deep Scan; não são autorização para implementar.

## P0/P1

- **P0 / SECURITY:** autorização por recurso ausente em `get/update/delete` de experimentos, tratamentos, enzimas e usuários; qualquer JWT válido pode acessar UUIDs alheios. CRUD de enzimas/usuários também não está restrito a ADMIN.
- **P1 / SCIENTIFIC DATA RISK:** cálculo dinâmico não valida fórmula, unidade, domínio ou divisão por zero; defaults (`duration`, pesos) e clamp de resultado inválido para zero ocultam erro experimental.
- **P1 / SECURITY:** CORS `allowedOriginPatterns("*")` com credenciais; PIN previsível (`Random`), armazenado sem hash e sem rate limit/expiração de tentativas.
- **P1 / DATA:** `ddl-auto=update`, sem migrations, seed ou estratégia de backup/reprodutibilidade.

## P2

- Cobertura mínima: um teste de entidade Flutter e um smoke test Spring; sem testes de cálculo, datasource, controller, segurança ou integração.
- Flutter tem cache somente de leitura em SharedPreferences; não há TTL, fila, sync ou conflitos. Cache pode ficar stale.
- DTOs usam `Map` dinâmico e defaults silenciosos; parse de números/strings e campos nulos pode mascarar contrato quebrado.
- Contrato de paginação/query diverge parcialmente (Flutter envia `limit/orderBy/ordering`; API usa paginação Spring), e há constantes legadas não usadas (`/auth/user`).
- Entidade `User` redeclara campos de `BaseEntity`; `EnzymeService` duplica branches de fórmula Urease e `update` altera `createdAt`.
- Não há workflow CI no app; Maven/Java e Flutter toolchain devem ser fixados e executados em pipeline.

## P3

- Acessibilidade, responsividade e avaliação SUS não têm evidência automatizada.
- Exportação XLSX não inclui versão de protocolo, app, API, unidades completas ou proveniência; usa URL HTTP legado no rodapé.
- `TODO` de certificate pinning e URL prod distinta permanece aberto; permissões Android/iOS e configuração de release precisam auditoria por plataforma.
