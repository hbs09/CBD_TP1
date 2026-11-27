# Contexto — Eduardo

> Para o Claude do Eduardo. Lê primeiro o `CLAUDE.md` da raiz e depois `planos/Eduardo.md`.

## Quem é e o que faz
O Eduardo faz o **Ex. 2b** e o **Ex. 3a**. É dono de:
- `sql/02b_trigger_auditoria.sql` — trigger `AuditaPrecosContratos`
- `sql/03a_pacote_grupo.sql` — pacote / procedimento / função do Ex. 3

Não edita mais nenhum ficheiro. Tabelas novas para o Ex. 3 são desenhadas com o Henrique e ficam no `00_setup.sql` (do Henrique).

## Prazos
| Data | Entrega |
|---|---|
| 24–25/nov | Estudar triggers (`CBD_pcap24`, `cap23`) e o modelo de dados |
| 25/nov | Pull + correr o setup no seu utilizador |
| 26/nov | Reunião do Ex. 3 (os três) — levar as ideias de `planos/Eduardo.md` |
| 27/nov | 2b concluído e testado |
| 28/nov | Tabelas do Ex. 3 (com Henrique) |
| 29/nov | **Especificação do pacote** fechada e combinada com o Henrique |
| 1/dez | 3a concluído + rever o trabalho do Henrique |
| 2/dez | Explicação do Ex. 3 em comentário + correções |

## Dependências
- **2b:** precisa do setup do Henrique (cópia de `CONTRATO` + `REGISTA_ALTERACOES_PRECOS`), previsto para 25/nov
- **3a:** precisa das tabelas do Ex. 3 (28/nov)
- **O 3b do Henrique depende do 3a:** a especificação do pacote (nomes, parâmetros, retornos) tem de estar fechada cedo. Mudanças na especificação → avisar o Henrique

## Particularidades a lembrar
- **2b — "efetivamente alterado":** `preco_contratual` é `NOT NULL` (`NUMBER(38,2)`, confirmado com `DESC`), por isso basta `:OLD.preco_contratual <> :NEW.preco_contratual`. Um `UPDATE` com o mesmo preço **não** regista nada
- **2b — delete:** registar com `novo_preco = NULL` e o objeto **anterior** (`:OLD.objeto`)
- O 2a do Henrique também tem trigger em `CONTRATO` → testar juntos um `DELETE`
- **3a:** a complexidade é valorizada → pacote com especificação + corpo, subprogramas privados, cursores (com parâmetros), exceção definida pelo utilizador, validação de parâmetros
- **Ex. 3: ideia A — Monitorização de ajustes diretos** (dados confirmados em `planos/Eduardo.md`, secção 2)
- **3a:** se uma função do pacote for chamada por um trigger de linha sobre uma tabela que ela própria consulta → erro de tabela mutante (`ORA-04091`). Combinar com o Henrique onde fica o trigger **antes** de fechar a especificação
- O enunciado exige uma **explicação resumida** do que se pretende com a proposta — no topo do ficheiro, em comentário
- Só elementos PL/SQL das aulas (secção 4 do `CLAUDE.md`)
