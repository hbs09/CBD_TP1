# Contexto — Henrique (organizador)

> Para o Claude do Henrique. Lê primeiro o `CLAUDE.md` da raiz e depois `planos/Henrique.md`.

## Quem é e o que faz
O Henrique organiza o grupo e o repositório. É dono de:
- `sql/00_setup.sql` — base comum de todos (**bloqueia o Eduardo** → prioridade máxima)
- `sql/02a_trigger_total.sql` — trigger `ActualizaTotalContratos`
- `sql/03b_trigger_grupo.sql` — trigger do Ex. 3
- `entrega/` — ficheiro final para o Moodle
- `README.md`, `CLAUDE.md`, `contexto/`, `planos/`

## Prazos
| Data | Entrega |
|---|---|
| 25/nov | `00_setup.sql` no repositório + avisar o grupo |
| 26/nov | Reunião do Ex. 3 (os três) |
| 27/nov | 2a concluído |
| 28/nov | Tabelas do Ex. 3 (com Eduardo) acrescentadas ao setup |
| 30/nov | 3b concluído |
| 1/dez | Rever o Ex. 1 do David |
| 2/dez | Junção + teste completo do ficheiro final |
| 4/dez (manhã) | Entrega no Moodle |

## Contratos com os outros (não mudar sem avisar)
O setup define nomes e colunas que os outros usam:
- `RESULTADO_LOCALIZACAO (id_contrato, objeto, pais, distrito, concelho, preco_contratual)` → usada pelo **David** (1b)
- `REGISTA_ALTERACOES_PRECOS (id_contrato, objeto, preco_antigo, novo_preco, data_alteracao)` → usada pelo **Eduardo** (2b); `novo_preco` tem de aceitar NULL
- Cópias de `CONTRATO` e `PROCEDIMENTO` com PK/FK → usadas pelo 2a, 2b e Ex. 3
- O 3b chama funções do pacote do **Eduardo** (3a): a especificação do pacote é combinada entre os dois **antes** de escreverem código

Sempre que o setup mudar: commit `[setup] ...` + avisar o grupo para voltarem a correr o setup.

## Particularidades a lembrar
- O setup tem de poder correr várias vezes (DROP no início; erros de "não existe" na 1.ª vez são aceitáveis)
- 2a e 2b têm triggers na mesma tabela `CONTRATO` → testar juntos um `DELETE`
- Ex. 2a ✅ concluído (27/nov): 3 triggers separados (`ActualizaTotalContratos`, `_DEL`, `_UPD` com `WHEN`) + testes
- Ex. 3: ideia **A — ajustes diretos** (ver `planos/Eduardo.md`, secção 2)
- No 3b, **evitar a tabela mutante por desenho**: o trigger não consulta a tabela onde está. O professor mostra `PRAGMA AUTONOMOUS_TRANSACTION`, mas avisa que tem problemas — só em último recurso
- Na junção: ordem `00 → 01a → 01b → 02a → 02b → 03a → 03b`; confirmar `/` após cada objeto; correr tudo num utilizador limpo

## Papel extra do Claude do Henrique
- Ajudar a manter `README.md` e os planos atualizados (checkboxes, alterações de prazos)
- Na junção, verificar que o ficheiro final cumpre **todas** as regras da secção 3 do `CLAUDE.md`
