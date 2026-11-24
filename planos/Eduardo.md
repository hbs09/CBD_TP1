# Plano — Eduardo

**Responsável por:** Ex. 2b · Ex. 3a (pacote / procedimento / função do grupo)
**Ficheiros:** `sql/02b_trigger_auditoria.sql`, `sql/03a_pacote_grupo.sql`
**Revês:** Henrique (setup + 2a + 3b) · **És revisto por:** David

> ⏳ Dependência: o 2b precisa das cópias de `CONTRATO` e da tabela `REGISTA_ALTERACOES_PRECOS`, que vêm no **setup do Henrique (25/nov)**.
> Até lá: estudar a ficha de triggers (`CBD_pcap24`) e o modelo de dados.

---

## 0. Preparação · 24–25/nov
- Ler o [dicionário de dados](../enunciado/Dicionario_Dados_Contratos.pdf)
- Rever na ficha `CBD_pcap24`: `:OLD` / `:NEW`, `FOR EACH ROW`, `UPDATING` / `DELETING`, `UPDATE OF coluna`
- Quando o setup sair: **Pull** → correr `00_setup.sql` no teu utilizador

---

## 1. Ex. 2b — `AuditaPrecosContratos` · 25–27/nov

### O que fazer
Trigger de linha sobre a cópia de `CONTRATO`, `AFTER UPDATE OF preco_contratual OR DELETE`:
- **UPDATE**, só se o preço mudou mesmo → `INSERT` em `REGISTA_ALTERACOES_PRECOS` com
  `:OLD.id_contrato`, `:OLD.objeto`, `:OLD.preco_contratual`, `:NEW.preco_contratual`, `SYSDATE`
- **DELETE** → mesmo registo mas com `novo_preco = NULL`

### Armadilhas
- **"Efetivamente alterado":** `preco_contratual` é `NOT NULL` (confirmado com `DESC`), por isso basta comparar `:OLD.preco_contratual <> :NEW.preco_contratual` — não é preciso tratar NULL no UPDATE
- `UPDATE OF preco_contratual` dispara mesmo que o valor seja igual (`SET preco = preco`) — por isso a comparação acima é obrigatória
- O objeto a guardar é o **anterior** (`:OLD.objeto`)
- O 2a do Henrique também tem trigger em `CONTRATO` — testem juntos um `DELETE` (devem disparar os dois sem conflito)

### Testes
- [ ] `UPDATE` com preço diferente → 1 registo novo
- [ ] `UPDATE` com o mesmo preço → **nenhum** registo
- [ ] `UPDATE` de outra coluna (ex. `objeto`) → nenhum registo
- [ ] `DELETE` → registo com `novo_preco` NULL
- [ ] `SELECT * FROM REGISTA_ALTERACOES_PRECOS` depois de cada caso + `ROLLBACK` no fim

---

## 2. Ex. 3 — decisão em grupo · 26/nov

Reunião dos três para escolher a ideia. A complexidade é valorizada, por isso a ideia deve ter: **regra de negócio real**, **várias tabelas**, **pacote** (em vez de um procedimento solto), **cursores**, **exceções próprias** e um **trigger** que faça validação ou registo.

### Ideias para o Ex. 3

**A) Monitorização de ajustes diretos (recomendada)**
Inspirada na regra do Código dos Contratos Públicos que limita ajustes diretos repetidos à mesma empresa.
- Tabelas extra: `PARAMETRO_LIMITE` (limite por tipo de contrato e janela de anos), `ALERTA` (id, entidade, contrato, tipo, valor acumulado, data)
- **3a — pacote `PKG_MONITORIZACAO`:**
  - função `Valor_Acumulado(adjudicante, adjudicatario, anos)` → soma de contratos por ajuste direto entre os dois
  - procedimento `Relatorio_Concentracao(adjudicante)` → lista as empresas mais contratadas, com % do total
  - procedimento `Gerar_Alertas` → percorre os pares e regista em `ALERTA` os que passam o limite
  - exceção própria para parâmetros inválidos
- **3b — trigger (Henrique):** sobre `CONTRATO_ENTIDADE` — ao associar um adjudicatário a um contrato por ajuste direto, calcula o acumulado (chamando a função do pacote, que lê `CONTRATO` sem problemas de tabela mutante) e regista um alerta ou bloqueia com `RAISE_APPLICATION_ERROR`

**B) Estatísticas por região e CPV**
- Pacote com rankings de valor por NUTS / distrito / código CPV, comparação entre regiões, contratos ecológicos vs não ecológicos
- Trigger que mantém uma tabela de totais por região sempre atualizada

**C) Validação de contratos**
- Pacote com regras de coerência (data de celebração ≥ publicação, prazo > 0, soma dos CPV vs preço, contrato sem adjudicatário)
- Trigger que valida antes de inserir/alterar e regista as violações

> Cada opção precisa de **cópias** das tabelas que o trigger toca (ex. `CONTRATO_ENTIDADE`, `ENTIDADE`) — o Henrique junta-as ao setup.

---

## 3. Ex. 3a — Pacote do grupo · 28/nov–1/dez

1. **28/nov:** desenhar com o Henrique as tabelas extra (ele põe-nas no setup)
2. **29–30/nov:** `CREATE PACKAGE` (especificação) primeiro → combina com o Henrique as assinaturas que o trigger dele vai chamar → depois `CREATE PACKAGE BODY`
3. **1/dez:** testes de cada procedimento/função + casos de erro (exceção própria a disparar)
4. **2/dez:** explicação em comentário no topo do ficheiro: o que o pacote faz, porquê, e como se liga ao trigger (o enunciado exige)

### Armadilhas
- Só usar o que foi dado nas aulas (ver `CBD_pcap23` — procedimentos, funções e pacotes)
- Definir a especificação **cedo**: o Henrique depende dela para o 3b
- Funções chamadas dentro do trigger **não podem** consultar a própria tabela `CONTRATO` que disparou (erro de tabela mutante) — combinem como evitar isso

---

## 4. Revisão · 1/dez
Rever o trabalho do **Henrique** (setup + 2a + 3b): correr o setup do zero, os testes do 2a e do 3b, e confirmar que o ficheiro final tem tudo.
