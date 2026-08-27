# Enzitech branch state

Deep Scan realizado em 2026-08-27. O checkout de desenvolvimento é `develop`, publicado como `origin/develop`; não existe ref local/remota chamada `dev` no clone.

| baseline | ref | commit | data | observação |
|---|---|---|---|---|
| produção | `main` / `origin/main` | `d2b5326eb0331ee3b30e0b729f252b6b40eefe98` | 2026-08-27 | ponta atual e tag `2.0.0` como ancestral |
| desenvolvimento | `develop` / `origin/develop` | `9d8cdc890c06038594fbba362e56283a84100d87` | 2026-08-26 | baseline ativa confirmada pelo histórico |

`git fetch --all --prune` foi tentado, mas o sandbox não permite escrever `.git/FETCH_HEAD`; as refs remotas já presentes foram usadas.

## Comparação

`main..origin/develop` não contém commits. `origin/develop..main` contém o merge da release `2.0.0` e `d2b5326`. O diff de conteúdo é somente:

- `LICENSE` MIT adicionado em `main`;
- badges Dart/Flutter corrigidos no `README.md`.

Logo, não há feature apenas em `develop` nem correção de produção ausente em `develop` dentro das refs observadas. As mudanças funcionais recentes (migração de API, edição de experimento, repetições parciais, recuperação de senha e hardening) já estão nos dois históricos. Para novas mudanças mobile, partir de `develop` conforme a política do projeto.

Branches de trabalho não integradas observadas: `feature-api-migration`, `feature-enzyme-formula-customization` e `security-upgrade`. A última contém o hardening já incorporado ao histórico de `main`/`develop`; a branch de customização de fórmula ainda não está na baseline.
