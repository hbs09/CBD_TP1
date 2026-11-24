# Plano — David

**Responsável por:** Ex. 1a · Ex. 1b
**Ficheiros:** `sql/01a_resumo_entidade.sql`, `sql/01b_procura_contratos.sql`
**Revês:** Eduardo (2b + 3a) · **És revisto por:** Henrique

> ✅ Podes começar **já**: o Ex. 1 só lê dados, usando `C##_TP1_2627.<tabela>` diretamente.
> A única dependência é a tabela `RESULTADO_LOCALIZACAO` (1b), que vem no setup do Henrique (25/nov).

---

## 0. Preparação · 24/nov

- Ler o [dicionário de dados](../enunciado/Dicionario_Dados_Contratos.pdf), sobretudo `ENTIDADE`, `CONTRATO_ENTIDADE`, `CONTRATO`, `CONTRATO_LOCAL_EXECUCAO`, `LOCAL_EXECUCAO`
- Explorar os dados no SQL Developer:
  ```sql
  SELECT * FROM C##_TP1_2627.ENTIDADE WHERE INSTR(UPPER(designacao), 'CASTELO BRANCO') > 0;
  SELECT DISTINCT descricao FROM C##_TP1_2627.LOCAL_EXECUCAO ORDER BY 1;
  ```
  A segunda consulta é importante para o 1b: vê **todos os formatos** de `descricao` que existem.

---

## 1. Ex. 1a — `Resumo_Entidade(p_nome)` · 24–27/nov

### O que fazer
1. Cursor sobre `ENTIDADE` com `INSTR(UPPER(designacao), UPPER(p_nome)) > 0`
2. Para cada entidade, calcular (com `SELECT ... INTO` ou cursores):
   - total de contratos **distintos** (`COUNT(DISTINCT id_contrato)` em `CONTRATO_ENTIDADE`)
   - nº e **soma de `preco_contratual`** como `ADJUDICANTE` (join com `CONTRATO`)
   - nº e soma como `ADJUDICATARIO`
3. Imprimir com `DBMS_OUTPUT.PUT_LINE` no formato do enunciado
4. Se o cursor não devolveu nenhuma linha → mensagem tipo "Não foram encontradas entidades com '...'"

### Armadilhas
- **Contagens duplicadas:** um join mal feito multiplica linhas. Confirma as contagens com uma consulta SQL simples antes de pôr no procedimento
- O valor vem de `CONTRATO.preco_contratual` (a `CONTRATO_ENTIDADE` não tem montantes)
- Somas sem linhas dão NULL → usar `NVL(..., 0)` para mostrar `0,00`
- Formato `637.252,34`: `TO_CHAR(valor, 'FM999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''')`
- `identificador_fiscal` pode ser NULL
- Para saber se não encontrou nada: contador ou `%ROWCOUNT` depois do ciclo

### Testes
- [ ] `Resumo_Entidade('Castelo Branco')` → tem de bater com o enunciado: **Município de Castelo Branco, ID 2007, NIF 501143530, 7 contratos, 637.252,34 como adjudicante, 0 como adjudicatário**
- [ ] `Resumo_Entidade('castelo branco')` → mesmo resultado (maiúsculas/minúsculas)
- [ ] `Resumo_Entidade('XYZ inexistente')` → mensagem de "não encontrado"
- [ ] Uma entidade que seja **adjudicatária** (uma empresa), para testar o outro papel

---

## 2. Ex. 1b — `Procura_Contratos_Concelho(p_distrito, p_concelho)` · 27–30/nov

### O que fazer
1. Função que devolve `NUMBER`
2. `DELETE FROM RESULTADO_LOCALIZACAO` (limpar antes)
3. Percorrer `CONTRATO` + `CONTRATO_LOCAL_EXECUCAO` + `LOCAL_EXECUCAO` (de `C##_TP1_2627`)
4. Separar `descricao` em país / distrito / concelho com `INSTR` e `SUBSTR` (procurar a 1.ª e 2.ª vírgula) + `TRIM`
5. Se distrito e concelho coincidirem (comparar com `UPPER`) → `INSERT` em `RESULTADO_LOCALIZACAO`
6. `RETURN 0` se inseriu pelo menos um, `RETURN 1` se não
7. `EXCEPTION WHEN OTHERS THEN RETURN 1`

### Armadilhas
- **Formatos variáveis:** há descrições só com "Portugal" ou "Portugal, Distrito" — sem 2.ª vírgula o `INSTR` dá 0 e o `SUBSTR` dá lixo. Trata esses casos
- Espaços depois das vírgulas → `TRIM`
- Acentos: "Covilhã" tem de ser escrito com ã nos testes (verifica o encoding do SQL Developer)
- Um contrato pode ter **vários locais** — evita inserir o mesmo contrato duas vezes para o mesmo concelho
- Uma função que faz `INSERT/DELETE` **não pode ser chamada dentro de um `SELECT`** — testa num bloco anónimo:
  ```sql
  DECLARE v NUMBER;
  BEGIN
    v := Procura_Contratos_Concelho('Castelo Branco', 'Covilhã');
    DBMS_OUTPUT.PUT_LINE('Retorno: ' || v);
  END;
  /
  SELECT * FROM RESULTADO_LOCALIZACAO;
  ```
- Combinar com o grupo se a função faz `COMMIT` ou não

### Testes
- [ ] `('Castelo Branco', 'Covilhã')` → retorno 0 e tabela preenchida
- [ ] Concelho inexistente → retorno 1 e tabela vazia
- [ ] Minúsculas (`'castelo branco', 'covilhã'`) → mesmo resultado
- [ ] Chamar duas vezes seguidas → a tabela não acumula resultados

---

## 3. Revisão · 1/dez
Rever o trabalho do **Eduardo** (2b + 3a): corre o setup, depois os ficheiros dele, e confirma que os testes dão o resultado esperado. Abre comentários no GitHub ou fala diretamente com ele.

## 4. 2/dez
Corrigir o que o Henrique apontar na revisão; confirmar que os teus ficheiros correm sem erros no ficheiro final.
