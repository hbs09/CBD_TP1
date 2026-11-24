# Contexto — David

> Para o Claude do David. Lê primeiro o `CLAUDE.md` da raiz e depois `planos/David.md`.

## Quem é e o que faz
O David faz o **Ex. 1** completo. É dono de:
- `sql/01a_resumo_entidade.sql` — procedimento `Resumo_Entidade`
- `sql/01b_procura_contratos.sql` — função `Procura_Contratos_Concelho`

Não edita mais nenhum ficheiro. Se precisar de algo no setup (ex. mudar `RESULTADO_LOCALIZACAO`), pede ao Henrique.

## Prazos
| Data | Entrega |
|---|---|
| 24/nov | Explorar os dados (`ENTIDADE`, `CONTRATO_ENTIDADE`, formatos de `LOCAL_EXECUCAO.descricao`) |
| 26/nov | Reunião do Ex. 3 (os três) |
| 27/nov | 1a concluído e testado |
| 30/nov | 1b concluído e testado |
| 1/dez | Rever o trabalho do Eduardo (2b + 3a) |
| 2/dez | Correções da revisão do Henrique |

## Dependências
- **1a:** nenhuma — lê diretamente de `C##_TP1_2627.*`. Pode começar já.
- **1b:** precisa da tabela `RESULTADO_LOCALIZACAO` do setup (Henrique, 25/nov). Até lá, pode desenvolver a lógica de separação da `descricao` num bloco anónimo.

## Resultado de referência (do enunciado)
`Resumo_Entidade('Castelo Branco')` tem de mostrar, para a primeira entidade:
```
Entidade: Município de Castelo Branco
ID: 2007 | Identificador fiscal: 501143530
Total de contratos distintos: 7
Como adjudicante: 7 contratos
Valor dos contratos como adjudicante: 637.252,34
Como adjudicatário: 0 contratos
Valor dos contratos como adjudicatário: 0,00
```
Se os números não baterem, o erro está nos joins/contagens — não no formato.

## Particularidades a lembrar
- A pesquisa **tem de usar `INSTR`** (exigido no enunciado), sem distinguir maiúsculas/minúsculas
- Valores formatados com ponto nos milhares e vírgula nas décimas
- O 1b é uma **função** que faz DML → testar num bloco anónimo, nunca dentro de um `SELECT`
- O 1b devolve `0` (registou pelo menos um) ou `1` (nada encontrado **ou** erro)
- `LOCAL_EXECUCAO.descricao` tem formatos variáveis — o Claude deve pedir ao David para correr `SELECT DISTINCT descricao ...` e analisar os casos reais antes de escrever o parsing
- Só elementos PL/SQL das aulas (secção 4 do `CLAUDE.md`) — nada de `REGEXP_*` para separar a string; usar `INSTR` + `SUBSTR`
