# Enzitech persistent context

Este arquivo resume o Deep Scan de 2026-08-27 para orientar tarefas futuras. O prompt mestre em `/home/lohhans/Downloads/Prompt Mestre para Codex — Enzitech.md` é a instrução permanente de processo; este documento é evidência do estado observado, não substitui o código.

## Baselines

- `main` é a referência de produção: `d2b5326`.
- `develop` (`origin/develop`, chamado `dev` no prompt) é a referência de desenvolvimento: `9d8cdc8`.
- `develop` é ancestral direto de `main`; não há funcionalidade exclusiva em `develop` nas refs disponíveis. `main` só adiciona LICENSE e corrige badges.

## Sistema em uma frase

Aplicativo Flutter para cadastrar tratamentos/enzimas, criar experimentos, preencher repetições de leituras de amostra/branco, calcular atividades enzimáticas no backend, visualizar progresso/resultados e exportar XLSX.

## Fontes analisadas

`enzitech_app`, `enzitech_api` (`7fc9b5b`), `lohhans/tcc` (`132ccd1`), `tcc_armstrong.pdf`, `paper.pdf`, `rsl-sbc-enzimas.pdf` e a Postman collection (hash idêntico à cópia do backend).

## Próximo foco recomendado

Antes de novas features: fechar autorização por recurso/roles, tornar cálculo e protocolos verificáveis/versionados, adicionar migrations e testes de contrato/cálculo, e projetar offline-first com sincronização explícita. Ver `TECH_DEBT.md`, `API_CONTRACT.md` e `ARCHITECTURE.md`.
