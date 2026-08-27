# Enzitech API contract (observado)

Base URL configurável no Flutter via `ENV`/`*_API_BASE_URL`; fallback atual de dev, stage e prod é `https://enzitech.api.bcccoworking.org`.

## Endpoints

| método | caminho | payload/retorno principal |
|---|---|---|
| POST | `/auth/login` | `{email,password}` -> `{token,user:{id,name,email,role}}` |
| POST | `/auth/forgot-password` | `{email}`; envia PIN |
| POST | `/auth/verify-pin` | `{email,token}` |
| POST | `/auth/reset-password` | `{email,token,newPassword}` |
| POST | `/users` | cadastro público `{name,email,password}` |
| GET/GET id/PUT id/DELETE id | `/users` | CRUD paginado/por UUID |
| PATCH | `/users/promote-admin` | `{email}`; requester deve ser ADMIN no service |
| DELETE | `/users/me` | apagamento da conta autenticada |
| GET/GET id/POST/PUT id/DELETE id | `/enzymes` | catálogo paginado e CRUD |
| GET | `/treatments` | tratamentos do usuário autenticado |
| GET | `/treatments/experiment/{experimentId}` | snapshots do experimento |
| POST/DELETE id | `/treatments` | criação `{name,description}` e soft delete |
| GET | `/experiments?finished=` | `{total,experiments:[...]}` do usuário |
| POST/PUT id/GET id/DELETE id | `/experiments` | criação/edição/detalhe/soft delete |
| POST | `/experiments/get-enzymes/{id}` | `{enzymes:[...]}` (body legado opcional) |
| GET | `/experiments/{id}/repetitions` | slots com IDs de snapshot, status e dados |
| POST | `/experiments/{id}/repetitions/preview` | `treatmentId`, `enzymeId`, `repetitionNumber`, `sample`, `whiteSample` |
| PUT | `/experiments/{id}/repetitions` | mesmo payload; persiste uma repetição isolada |
| GET | `/experiments/get-total-result/{id}` | `{result:[{enzyme,processes:[{process,results:[]}]}]}` |

Criação/edição de experimento usa `name`, `description`, `repetitions`, `processes` (UUIDs de tratamentos globais) e `experimentsEnzymes` (`enzyme` = UUID global + variáveis e parâmetros). A resposta de detalhe contém `processes`, `experimentEnzymes` (snapshot completo) e `enzymes` (projeção).

## IDs e compatibilidade

Depois do snapshot, `experimentEnzyme.id` e `experimentTreatment.id` são IDs internos do experimento. São esses IDs que devem ser enviados ao preview/save de repetição; não devem ser substituídos pelos IDs globais `sourceEnzymeId`/`sourceTreatmentId`. O Flutter filtra e envia os IDs dos snapshots.

O Flutter aceita tanto `content` quanto `experiments`/`total`, mas monta query com `orderBy`, `ordering` e `limit`; a API atual documenta/implementa `finished` e paginação Spring (`page`, `size`, `sort`). Esses parâmetros extras não têm contrato garantido.

## Segurança e erros

JWT Bearer é validado por filtro, BCrypt protege senhas e `credentialsUpdatedAt` revoga tokens antigos. CORS aceita qualquer origem com credenciais. Não há `@PreAuthorize` nos CRUDs de usuário/enzima e os serviços por UUID não verificam proprietário do experimento/tratamento; isso permite IDOR a qualquer usuário autenticado. O PIN de recuperação usa `java.util.Random`, fica persistido em texto e há pouca proteção contra enumeração/rate abuse.
