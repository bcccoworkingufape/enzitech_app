# Validation evidence

Data: 2026-08-27. Esta página registra comandos executados durante o Deep Scan; não representa uma alteração funcional.

## Flutter/Dart

Comando:

```text
/home/lohhans/fvm/versions/stable/bin/cache/dart-sdk/bin/dart analyze
```

Resultado: `No issues found!`.

`flutter analyze` não iniciou pelo wrapper FVM porque o SDK tentou atualizar arquivos no cache protegido. `flutter test` executado pelo Dart puro não é válido para este projeto, pois `flutter_test` depende de `dart:ui`; o runner Flutter precisa ser executado em um ambiente Flutter funcional.

## API

Ambiente: OpenJDK `21.0.12`; Maven Wrapper `3.9.16`; repositório clonado em `/tmp/enzitech_api`; HEAD `7fc9b5b`.

Comando de compilação:

```text
MAVEN_USER_HOME=/tmp/enzitech_maven_home bash mvnw \
  -Dmaven.repo.local=/tmp/enzitech_m2 test-compile -q
```

Resultado: aprovado (código principal e testes compilados).

Comando de testes:

```text
MAVEN_USER_HOME=/tmp/enzitech_maven_home bash mvnw \
  -Dmaven.repo.local=/tmp/enzitech_m2 test -q
```

Resultado: 1 teste executado, 0 failures, 1 error. `EnzitechApplicationTests.contextLoads` falha antes da carga do contexto porque `application.properties` exige `SMTP_HOST` (e demais variáveis SMTP/DB) via `.env`. Não há arquivo `.env` versionado e não foram fornecidas credenciais de infraestrutura. O relatório está em `target/surefire-reports/` no checkout temporário.

`package -DskipTests` não foi usado como evidência final: o cache offline não possuía `maven-jar-plugin:3.5.0`. Isso não invalida o resultado de `test-compile`.

## Próxima melhoria de testes

Adicionar perfil `test` hermético, banco efêmero (por exemplo, PostgreSQL de teste/Testcontainers), valores SMTP seguros de teste e testes unitários para cálculo, autorização, DTOs e controllers. O objetivo é que `mvn test` não dependa de segredos ou serviços externos.
