# Architecture decisions and context

## Context

O Enzitech nasceu no TCC para substituir papel -> planilha -> fórmula manual por entrada estruturada, cálculo e exportação de atividades enzimáticas do solo. O TCC descreve Flutter, MVVM, Clean Architecture, backend TypeScript/Nest.js e PostgreSQL.

## Current decisions observed

- O app mantém a separação Presentation/Domain/Data e usa ViewModels `ChangeNotifier`.
- O backend atual centraliza cálculo e persistência em um monólito Java/Spring, divergindo do backend Nest.js descrito historicamente.
- Experimentos copiam configurações de tratamentos/enzimas para preservar histórico; remoções com resultados concluídos tornam snapshots inativos.
- Repetições são slots materializados para cada combinação tratamento × enzima e podem ser salvas isoladamente.
- O cliente mantém cache de leitura e usa secure storage para JWT, mas não implementa offline-first completo.
- Fórmulas permanecem no catálogo/snapshot e são interpretadas por exp4j; não há versionamento explícito de protocolo/cálculo.

## Consequences

Essas escolhas facilitam evolução incremental e preservam configurações históricas, mas aumentam a importância de autorização por recurso, validação das fórmulas/parâmetros, migrations, testes de cálculo/contrato e metadados de proveniência. Qualquer futura estratégia offline deve definir fila, idempotência e conflitos antes de alterar o modelo.

## Alternatives for future ADRs

Avaliar formalmente: catálogo de protocolos versionados; cálculo compartilhado/contratualizado; migrations Flyway/Liquibase; autorização centralizada por proprietário/ADMIN; persistência local estruturada; sincronização offline; schema OpenAPI gerado e testes de contrato.
