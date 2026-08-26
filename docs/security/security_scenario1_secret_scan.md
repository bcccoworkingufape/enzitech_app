# CENARIO 1 - Evidencia de varredura de segredos hardcoded

Escopo: Enzitech App (Flutter), branch `OWASP-hardening`.

Objetivo: registrar a verificacao explicita de segredos hardcoded solicitada na
extensao da analise para OWASP Mobile Top 10 2024. A varredura complementa a
base MASVS/MASTG ja existente; ela nao substitui os controles STORAGE, CODE,
NETWORK e PLATFORM usados no CENARIO 1.

## Comando executado

```powershell
rg -n "(?i)(api[_-]?key|client[_-]?secret|private[_-]?key|access[_-]?token|refresh[_-]?token|bearer\s+[A-Za-z0-9._-]+|AIza[0-9A-Za-z_-]{30,})" lib android ios pubspec.yaml pubspec.lock
```

```powershell
rg --files -g "*.env" -g "*.pem" -g "*.jks" -g "*.p12" -g "*.keystore" -g "key.properties"
```

## Resultado triado

| Grupo | Ocorrencias | Classificacao | Evidencia |
|-------|-------------|---------------|-----------|
| Segredos privilegiados hardcoded | 0 | Mitigado | Nao foram encontrados `client_secret`, chave privada, refresh token, bearer token literal ou senha de servico embutida. |
| Arquivos sensiveis versionados | 0 | Mitigado | Nao foram encontrados `.env`, `.pem`, `.jks`, `.p12`, `.keystore` ou `key.properties` no workspace versionado. |
| Firebase client API keys | 3 | Aceito/documentado | `lib/firebase_options.dart` contem 3 `apiKey` de cliente Firebase. Sao identificadores publicos de configuracao do app e nao credenciais privilegiadas por si so; devem permanecer protegidos por regras Firebase/Firestore/Auth no backend Firebase. |
| Tokens de sessao em codigo | 0 | Mitigado | Ocorrencias de `accessToken`, `Authorization` e `Bearer` sao tipos, campos DTO ou montagem dinamica do header; o valor real vem do login e fica em `SecureSessionStorage`. |

## Relacao OWASP Mobile Top 10 2024

| Risco | Interpretacao no CENARIO 1 | Estado apos extensao |
|-------|-----------------------------|----------------------|
| M1 - Improper Credential Usage | Evitar credenciais e tokens persistidos de forma insegura ou embutidos no codigo. | Cobertura reforcada: token em secure storage, migracao do legado e varredura formal com 0 segredos privilegiados. |
| M2 - Inadequate Supply Chain Security | Firebase keys exigem configuracao segura no ecossistema Firebase, regras de acesso e revisao de dependencias. | Parcial: dependencia e configuracao registradas; regras Firebase/backend fora do escopo do app Flutter. |
| M8 - Security Misconfiguration | Chaves publicas de cliente podem se tornar risco quando combinadas com regras permissivas. | Parcial: evidencia registrada; validacao de regras Firebase/backend fica como trabalho futuro. |
| M9 - Insecure Data Storage | Tokens reais nao devem ficar em SharedPreferences ou JSON persistido. | Cobertura plena para token; cache offline permanece trade-off documentado. |
| M10 - Insufficient Cryptography | Armazenamento criptografado de token via mecanismos nativos. | Cobertura parcial/plena para storage local de token; pinning segue pendente. |

## Metricas antes/depois

| Metrica | Antes | Depois |
|---------|-------|--------|
| Varredura formal de segredos hardcoded | Nao registrada no baseline documental | Registrada neste arquivo |
| Segredos privilegiados hardcoded confirmados | Risco desconhecido no baseline | 0 |
| Firebase client API keys triadas | Nao triadas | 3 identificadores publicos documentados |
| Tokens reais persistidos fora de secure storage | 2 locais inseguros no baseline (`token` em SharedPreferences + `accessToken` no JSON `user`) | 0 |

## Limitacoes

- A varredura e estatica e baseada em padroes textuais; ela nao substitui uma
  ferramenta SAST dedicada nem auditoria de configuracoes no Firebase Console.
- Nao houve consulta a backend, Firebase Rules ou secrets remotos; estes
  permanecem fora do escopo do CENARIO 1.
