# Plano — Henrique (organizador)

**Responsável por:** Setup · Ex. 2a · Ex. 3b (trigger do grupo) · Junção final e entrega
**Ficheiros:** `sql/00_setup.sql`, `sql/02a_trigger_total.sql`, `sql/03b_trigger_grupo.sql`, `entrega/TP1_..._INF.sql`
**Revês:** David (Ex. 1) · **És revisto por:** Eduardo

> ⚠️ O setup **bloqueia** o Eduardo (2b) — é a primeira coisa a sair. Meta: **25/nov no repositório**.

---

## 1. Setup — `00_setup.sql` · 24–25/nov

### O que fazer
1. **Remoção** (o enunciado exige código de criação **e** remoção):
   `DROP TABLE ... CASCADE CONSTRAINTS` para cada tabela do grupo. Na primeira execução vão dar erro "tabela não existe" — é normal; deixa um comentário a dizer isso.
2. **Cópias** de `C##_TP1_2627`:
   - `PROCEDIMENTO` → depois `ALTER TABLE ... ADD CONSTRAINT ... PRIMARY KEY (id_procedimento)`
   - `CONTRATO` → PK `(id_contrato)` + FK `id_procedimento → PROCEDIMENTO`
   - Ordem: `PROCEDIMENTO` antes de `CONTRATO` (por causa da FK); nos DROP, ao contrário.
3. **`total_contratos`:**
   - `ALTER TABLE PROCEDIMENTO ADD total_contratos NUMBER DEFAULT 0 NOT NULL`
   - `UPDATE` com subconsulta `COUNT(*)` dos contratos de cada procedimento → `COMMIT`
4. **Tabelas auxiliares** (colunas exatamente como no enunciado):
   - `RESULTADO_LOCALIZACAO (id_contrato, objeto, pais, distrito, concelho, preco_contratual)` — usada pelo David
   - `REGISTA_ALTERACOES_PRECOS (id_contrato, objeto, preco_antigo, novo_preco, data_alteracao)` — usada pelo Eduardo
   - Dica: para herdar os tipos certos de `id_contrato`, `objeto` e `preco_contratual`, podes criar com `CREATE TABLE ... AS SELECT ... FROM C##_TP1_2627.contrato WHERE 1=0`
   - ⚠️ `novo_preco` **tem de aceitar NULL** (o delete do 2b regista NULL)

### Verificar antes do push
- [ ] O script corre duas vezes seguidas sem erros (fora os DROP da 1.ª vez)
- [ ] `SELECT COUNT(*)` das cópias = `SELECT COUNT(*)` das originais
- [ ] `SUM(total_contratos)` = nº de contratos com `id_procedimento` preenchido
- [ ] Push + avisar o grupo: **"setup pronto, corram no vosso utilizador"**

---

## 2. Ex. 2a — `ActualizaTotalContratos` · 26–27/nov

### O que fazer
Trigger de linha (`FOR EACH ROW`) sobre a tua cópia de `CONTRATO`, `AFTER INSERT OR DELETE OR UPDATE OF id_procedimento`:
- `INSERTING` → `total_contratos + 1` no `:NEW.id_procedimento`
- `DELETING` → `total_contratos - 1` no `:OLD.id_procedimento`
- `UPDATING` → só se o id mudou: −1 no `:OLD`, +1 no `:NEW`

O enunciado fala em "variantes": podes fazer **um trigger com `INSERTING/DELETING/UPDATING`** ou **três triggers**. Vê na ficha `CBD_pcap24` qual o estilo dado nas aulas.

### Armadilhas
- `id_procedimento` pode ser NULL → não atualizar nada nesse caso
- Comparar "mudou" com NULL: `:OLD.x <> :NEW.x` não apanha NULL ↔ valor
- O 2b (Eduardo) também tem triggers em `CONTRATO` — testem juntos que não interferem

### Testes (no fim do ficheiro)
- [ ] `INSERT` de um contrato → total do procedimento +1
- [ ] `DELETE` desse contrato → volta ao valor inicial
- [ ] `UPDATE` de `id_procedimento` para outro → antigo −1, novo +1
- [ ] `UPDATE` de outra coluna (ex. `objeto`) → totais iguais
- [ ] `ROLLBACK` no fim para não estragar os dados

---

## 3. Ex. 3b — Trigger do grupo · 28–30/nov

1. **26/nov:** reunião dos três para decidir a ideia do Ex. 3 (ver sugestões em [Eduardo.md](Eduardo.md#ideias-para-o-ex-3))
2. **28/nov:** desenhar com o Eduardo as tabelas extra → acrescentar ao `00_setup.sql` (secção `-- EX. 3`) → push
3. **29–30/nov:** escrever o trigger
   - Para valorizar a complexidade: regra de negócio real, consulta a outras tabelas, `RAISE_APPLICATION_ERROR` quando a regra é violada, registo numa tabela de log/alertas
   - Se fizer sentido, o trigger **chama** funções do pacote do Eduardo (mostra integração)
4. Testes + explicação em comentário (o enunciado exige)

---

## 4. Revisão e junção · 1–4/dez

- **1/dez:** rever o Ex. 1 do David — corre os testes dele, confirma o exemplo do enunciado (`'Castelo Branco'` → ID 2007, 7 contratos, 637.252,34)
- **2/dez:** junção:
  - Concatenar pela ordem: `00 → 01a → 01b → 02a → 02b → 03a → 03b`
  - Correr o ficheiro final **inteiro** num utilizador limpo (ou depois de correr só os DROP)
  - Confirmar que cada `CREATE PROCEDURE/FUNCTION/TRIGGER/PACKAGE` termina com `/`
  - Nome: `TP1_HenriqueNum_DavidNum_EduardoNum_INF.sql`
- **3/dez:** margem para correções
- **4/dez, de manhã:** entregar no Moodle e avisar o grupo
