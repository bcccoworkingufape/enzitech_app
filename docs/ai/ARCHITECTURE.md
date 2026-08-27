# Enzitech architecture (Deep Scan)

## Mobile

Flutter/Dart organizado por feature (`authentication`, `enzyme`, `experiment`, `treatment`, `main`) e por camadas `presentation`, `domain` e `data`, com serviços transversais em `core` e UI/validadores/localização em `shared`.

Fluxo nominal: Page/Widget -> ViewModel (`ChangeNotifier`) -> Use Case -> repository abstrato -> repository implementation -> DataSource remoto/local -> `DioHttpServiceImp` -> REST API. `GetIt` registra serviços, datasources, repositories, use cases e viewmodels. `dartz Either<Failure,T>` transporta erros.

O estado é majoritariamente `ChangeNotifier` + `ListenableBuilder`. Rotas são manuais em `Routing`; não há router declarativo. A inicialização configura Firebase Crashlytics, ambiente por `--dart-define`, migração de token para secure storage, cliente HTTP e preferências.

## Data/offline

Enzimas, tratamentos e listagem de experimentos usam decorators que gravam/recuperam JSON em `SharedPreferences`. É cache de leitura, sem fila de mutações, resolução de conflitos, TTL ou sincronização offline completa. Logout limpa token seguro, headers/interceptors e preferências/caches conhecidos.

## Backend

Monólito Spring Boot 4.1 / Java 21 com Spring MVC, Validation, Data JPA/Hibernate, Security, JWT, Thymeleaf/Mail, SpringDoc e exp4j. Controllers implementam interfaces `controller/api` anotadas com OpenAPI; services concentram persistência e cálculo; repositories são `JpaRepository`; entidades JPA usam UUID, auditoria e soft delete via `@SQLDelete`/`@SQLRestriction`.

Banco atual: PostgreSQL configurado por `.env`; `spring.jpa.hibernate.ddl-auto=update`. Não foram encontrados migrations versionados. Docker Compose usa PostgreSQL 13 e uma imagem placeholder `ghcr.io/seu_usuario/seu_repositorio:latest`.

## Domínio

`User` (USER/ADMIN), `Enzyme`, `Treatment`, `Experiment`, snapshots `ExperimentEnzyme`/`ExperimentTreatment`, `ResultExperiment` (slot de repetição PENDING/COMPLETED) e `PasswordResetToken`. Um experimento possui usuário, número de repetições, progresso, tratamentos e configurações/snapshots de enzimas; resultados referenciam IDs dos snapshots, não os IDs globais.

## Cálculo

`CalculateExperimentService` calcula `difference = sample - whiteSample`, aplica fórmula de curva com `difference`, `variableA`, `variableB`, e fórmula final com `curve`, `size`, `duration`, `weightSample`, `weightGround`. Fórmulas são strings gravadas no snapshot e avaliadas por exp4j. Valores finais NaN/infinito/negativos são silenciosamente convertidos em `0.0`; parâmetros inválidos recebem defaults, o que é risco científico.
