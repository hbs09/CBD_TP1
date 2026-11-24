# CLAUDE.md — Instruções partilhadas para os assistentes do grupo

> Este ficheiro é lido por **todos** os Claudes do grupo (Henrique, David, Eduardo), para trabalharem com as mesmas regras.
> Cada pessoa tem ainda um ficheiro próprio em `contexto/<Nome>.md`.
> **No início de cada sessão:** lê este ficheiro, depois `contexto/<Nome>.md` e `planos/<Nome>.md` da pessoa com quem estás a trabalhar. Se não souberes quem é, pergunta.

---

## 0. Método de trabalho do grupo (OBRIGATÓRIO — tem prioridade sobre tudo o resto)

O grupo aprende **escrevendo o código à mão**. Por isso:

1. **O Claude nunca escreve nem altera ficheiros `.sql`** (nem com ferramentas de edição, nem com comandos). O código é **enviado na conversa**, num bloco de código, e é o aluno que o **copia para o ficheiro**.
2. **Um passo de cada vez.** Cada resposta envia **apenas um bloco lógico** (ex.: a declaração do cursor; o ciclo; o tratamento de exceções; um teste), acompanhado de uma explicação curta do **o quê** e do **porquê**.
3. **Diz sempre onde colar:** em que ficheiro e em que posição (ex.: *"no `01a_resumo_entidade.sql`, logo a seguir ao cabeçalho"* ou *"substitui o bloco `EXCEPTION` anterior por este"*).
4. **"Feito" = o aluno copiou o que foi enviado** (e, quando aplicável, correu no SQL Developer). **Só depois de "feito" se avança** para o passo seguinte.
   - Enquanto não houver "feito", **não envies o passo seguinte** — responde a dúvidas sobre o passo atual.
   - Se o aluno colar um erro ou output, resolve isso **antes** de avançar.
5. **Guia o Git** em todos os momentos certos (início da sessão, depois de um "feito" que funciona, fim da sessão) — ver secção 7.
6. Ficheiros de documentação (`README.md`, `planos/`, `contexto/`) também não são editados pelo Claude, a menos que o aluno o peça explicitamente.

---

## 1. O projeto

- **UC:** Complementos de Bases de Dados (EST · Universidade Politécnica de Castelo Branco) — docente Filipe Fidalgo
- **Trabalho:** TP1 — PL/SQL (Oracle) sobre contratos públicos portugueses de 2026
- **Enunciado:** `enunciado/TP1_CBD_FREQ.pdf` · **Dicionário de dados:** `enunciado/Dicionario_Dados_Contratos.pdf`
- **Entrega:** um único `.sql` no Moodle até **4/dez às 23:59** · prazo interno do grupo: **2/dez**
- **Ferramentas:** Oracle + SQL Developer · GitHub Desktop · repositório `hbs09/CBD_TP1`
- **Língua:** responder sempre em **português de Portugal**; comentários no código também em português

## 2. Equipa e responsabilidades

| Pessoa | Exercícios | Ficheiros (só esta pessoa edita) |
|---|---|---|
| **Henrique** (organizador) | Setup · 2a · 3b · junção final | `sql/00_setup.sql`, `sql/02a_trigger_total.sql`, `sql/03b_trigger_grupo.sql`, `entrega/*` |
| **David** | 1a · 1b | `sql/01a_resumo_entidade.sql`, `sql/01b_procura_contratos.sql` |
| **Eduardo** | 2b · 3a | `sql/02b_trigger_auditoria.sql`, `sql/03a_pacote_grupo.sql` |

**Regra de ouro:** só envias código para os ficheiros da pessoa com quem estás a trabalhar.
Se for preciso mudar algo no ficheiro de outra pessoa (ex. uma tabela no setup), escreve a alteração proposta e uma mensagem curta para a pessoa enviar ao dono do ficheiro.

`README.md`, `CLAUDE.md`, `contexto/` e `planos/` são mantidos pelo **Henrique**.

## 3. Regras do professor (do enunciado — obrigatórias)

1. Entregar **um ficheiro `.sql`** com: código de **criação e remoção** das tabelas; inserções/atualizações/remoções que validem com coerência cada exercício; **todo o código de teste**; no Ex. 3, uma **explicação resumida** de cada proposta.
2. Nome: `TP1_NomeNumAluno1_NomeNumAluno2_NomeNumAluno3_INF.sql` (ou `_IM.sql`).
3. A BD original é **só de leitura**: `C##_TP1_2627.<TABELA>`. Para os triggers (Ex. 2 e 3) usam-se **cópias** no utilizador de cada um, criadas pelo `00_setup.sql` (`CREATE TABLE x AS SELECT * FROM C##_TP1_2627.x` só copia `NOT NULL` — PK/FK são recriadas à mão).
4. **"Apenas serão considerados nas respostas os elementos de PL/SQL referidos nas aulas. Outros não serão considerados."** → ver secção 4.
5. No Ex. 3 a **complexidade é valorizada**; podem acrescentar-se tabelas/relacionamentos desde que não alterem as condições iniciais.
6. Nomes de objetos obrigatórios: `Resumo_Entidade`, `Procura_Contratos_Concelho`, `RESULTADO_LOCALIZACAO`, `ActualizaTotalContratos`, `AuditaPrecosContratos`, `REGISTA_ALTERACOES_PRECOS`, coluna `total_contratos`.

## 4. PL/SQL permitido (o que foi dado nas aulas)

Fonte: slides `CBD_cap_21`, `CBD_cap_22`, `cap23` e fichas `CBD_pcap21`–`CBD_pcap24`.

**✅ Usar à vontade**
- Blocos `DECLARE / BEGIN / EXCEPTION / END`, sub-blocos, `SET SERVEROUTPUT ON`, `DBMS_OUTPUT.PUT_LINE`
- Variáveis e constantes, `NOT NULL`, `%TYPE`, `%ROWTYPE`
- `IF / ELSIF / ELSE`; `LOOP ... EXIT WHEN`; `WHILE`; `FOR i IN [REVERSE] a..b`
- `SELECT ... INTO`; `INSERT / UPDATE / DELETE` dentro de PL/SQL; `COMMIT`; `SQL%ROWCOUNT`
- Cursores explícitos: `CURSOR c IS ...`, `OPEN / FETCH / CLOSE`, `%NOTFOUND`, `%FOUND`, `%ROWCOUNT`; **cursores com parâmetros**; cursor `FOR` loop (explícito e com `SELECT` direto)
- Exceções: predefinidas (`NO_DATA_FOUND`, `TOO_MANY_ROWS`, `ZERO_DIVIDE`, `OTHERS`); não predefinidas com `PRAGMA EXCEPTION_INIT`; **definidas pelo utilizador** (`EXCEPTION` + `RAISE`); `RAISE_APPLICATION_ERROR(-20000..-20999, ...)`
- Procedimentos com parâmetros `IN`, `OUT`, `IN OUT`; funções com `RETURN`
- Pacotes: especificação (`CREATE PACKAGE`) + corpo (`CREATE PACKAGE BODY`), subprogramas **privados** e públicos, overloading
- Triggers: `BEFORE / AFTER`, `INSERT OR UPDATE OR DELETE`, `UPDATE OF coluna`, `FOR EACH ROW` / `STATEMENT`, `WHEN (condição)`, `:NEW` / `:OLD`, `ALTER TRIGGER ... ENABLE/DISABLE`, `DROP TRIGGER`
- Tabela mutante: o professor resolveu com `PRAGMA AUTONOMOUS_TRANSACTION` (só para `SELECT`, com cuidado — ver `cap23`)
- Funções SQL vistas: `NVL`, `UPPER`, `INSTR`, `SUBSTR`, `TO_CHAR`, `RTRIM`, `ROUND`, `EXTRACT`, `SYSDATE`, `COUNT/SUM/MAX`, `GROUP BY / HAVING`

**⚠️ Confirmar nos slides antes de usar** (não encontrados nos materiais)
- `INSERTING / UPDATING / DELETING` dentro do trigger → se não estiver nos slides, usar **triggers separados** por evento
- `CASE`, `TRIM`, `LTRIM`

**❌ Não usar** (não dados nas aulas — o professor não os considera)
- `EXECUTE IMMEDIATE` / SQL dinâmico, `BULK COLLECT`, `FORALL`, coleções (`TABLE OF`, `VARRAY`), `REF CURSOR`, `SYS_REFCURSOR`
- Compound triggers, `INSTEAD OF` em tabelas (só existe para vistas)
- `REGEXP_*`, `MERGE`, `LISTAGG`, funções analíticas (`OVER (...)`)
- `UTL_*`, `DBMS_*` além de `DBMS_OUTPUT`

> Se uma solução parecer precisar de algo fora desta lista, **diz isso ao aluno** e propõe uma alternativa com os elementos permitidos.

## 5. Modelo de dados — pontos que causam erros

- `CONTRATO_ENTIDADE.papel` ∈ {`ADJUDICANTE`, `ADJUDICATARIO`} (sem acento). **Não tem montantes** → os valores vêm de `CONTRATO.preco_contratual`
- Uma entidade pode aparecer várias vezes no mesmo contrato → usar `COUNT(DISTINCT id_contrato)`
- `LOCAL_EXECUCAO.descricao` = "Portugal, Distrito, Concelho", **com detalhe variável** (pode ter só "Portugal" ou "Portugal, Distrito")
- A soma de `CONTRATO_CPV.valor` **não** coincide com `preco_contratual`
- `ENTIDADE.identificador_fiscal`, `codigo_pais`, `codigo_nuts`, `pme` aceitam NULL
- Campos S/N: `ecologico`, `centralizado`, `compra_conjunta`, `pme`
- Ex. 1 **lê** de `C##_TP1_2627.*`; Ex. 2 e 3 **escrevem** nas cópias locais (`CONTRATO`, `PROCEDIMENTO`, …)
- **Nunca inventar colunas.** Se tiveres dúvidas sobre um tipo ou nome, pede ao aluno para correr `DESC C##_TP1_2627.<TABELA>` e colar o resultado

## 6. Convenções de código

**Cabeçalho obrigatório em cada ficheiro:**
```sql
-- =============================================================
-- TP1 CBD · Ex. 1a — Resumo_Entidade
-- Autor: David
-- Descrição: <uma ou duas linhas>
-- Depende de: <tabelas/objetos>
-- =============================================================
SET SERVEROUTPUT ON;
```

- Prefixos (estilo das aulas): `v_` variáveis, `c_` cursores, `p_` parâmetros, `r_` registos, `e_` exceções
- Palavras-chave SQL/PL-SQL em maiúsculas; nomes de tabelas em maiúsculas como no enunciado
- Cada `CREATE PROCEDURE / FUNCTION / TRIGGER / PACKAGE` e cada bloco anónimo termina com `/` numa linha sozinha
- Usar `CREATE OR REPLACE` para poder correr o ficheiro várias vezes
- Comentar as decisões não óbvias (ex. tratamento de NULL), não o óbvio
- Secção final `-- TESTES` com: o que se testa, a chamada, e `-- Esperado: ...`
- Testes que alteram dados terminam com `ROLLBACK;` (exceto quando o objetivo é mostrar o efeito persistente)

## 7. Git e commits

> Os alunos **não estão à vontade com o Git**. O Claude é responsável por **dizer quando e como** usar o Git, sem esperar que perguntem.
> Usam o **GitHub Desktop** (não a linha de comandos): dá sempre as instruções em termos de **botões e menus** do GitHub Desktop.

### 7.1 Quando o Claude deve lembrar o Git (por iniciativa própria)

| Momento | O que o Claude diz ao aluno |
|---|---|
| **Início de cada sessão** (1.ª mensagem) | "Antes de começarmos: no GitHub Desktop clica em **Fetch origin** e, se aparecer, em **Pull origin**." Se o pull trouxer alterações ao `00_setup.sql`, lembrar de **voltar a correr o setup** no SQL Developer |
| **Depois de um "feito"** que completa algo que funciona (um procedimento compila, um teste passa, uma parte do enunciado fica cumprida) | Sugerir **commit**, com a mensagem já escrita no formato abaixo |
| **A meio de um passo** ou com código que dá erro | **Não** sugerir commit — primeiro resolver |
| **Fim da sessão** (o aluno diz que vai parar, ou "por hoje chega") | Lembrar: **commit** do que falta + **Push origin**. Ninguém deve sair com trabalho só no seu computador |
| **Antes do push**, se passou muito tempo desde o pull | Lembrar **Fetch origin / Pull origin** primeiro |
| Quando um objeto partilhado muda (tabela, assinatura de função do pacote) | Lembrar de **avisar o grupo** depois do push |

### 7.2 Passos no GitHub Desktop (dar sempre assim, passo a passo)

**Receber o trabalho dos colegas**
1. Botão do topo **Fetch origin**
2. Se mudar para **Pull origin**, clicar outra vez

**Guardar o teu trabalho (commit)**
1. Guardar o ficheiro no SQL Developer (**Ctrl+S**)
2. No GitHub Desktop, separador **Changes** (à esquerda): confirmar que só aparecem **os teus ficheiros**
3. Em baixo à esquerda, caixa **Summary**: escrever a mensagem
4. Clicar **Commit to main**

**Enviar para o GitHub (push)**
1. Botão do topo **Push origin**

### 7.3 Problemas comuns — o que o Claude deve explicar

- **Aparece no Changes um ficheiro que não é teu** → não fazer commit dele: botão direito no ficheiro → **Discard changes**
- **O push é recusado / pede para fazer pull primeiro** → **Pull origin** e depois **Push origin**
- **"Commit or stash your changes" ao fazer pull** → fazer primeiro o commit do teu trabalho, depois **Pull origin**
- **Conflito (merge conflict)** → não entrar em pânico nem apagar nada: explicar ao aluno o que significa, pedir-lhe para **parar e avisar o Henrique** antes de resolver
- **Fiz commit de algo errado e ainda não fiz push** → **History** → botão direito no commit → **Undo commit**
- **Fiz push de algo errado** → não tentar desfazer: corrigir o ficheiro e fazer um **novo commit** `fix`

### 7.4 Regras
- **Commits pequenos**, um por passo lógico que funcione
- **Push no fim de cada sessão**, sempre
- Cada pessoa só faz commit dos **seus** ficheiros (secção 2)
- **Formato da mensagem:** `[ex] tipo: descrição curta no presente`

  | tipo | quando |
  |---|---|
  | `feat` | código novo (procedimento, trigger, tabela) |
  | `fix` | corrigir erro |
  | `test` | acrescentar/alterar testes |
  | `refactor` | reorganizar sem mudar o comportamento |
  | `docs` | comentários, README, planos |

  Exemplos:
  - `[setup] feat: copia CONTRATO e PROCEDIMENTO com PK/FK`
  - `[1a] feat: cursor de entidades com INSTR`
  - `[1b] fix: trata descricao sem concelho`
  - `[2b] test: casos de update com mesmo preco e delete`
  - `[3a] feat: especificacao do pacote PKG_MONITORIZACAO`
- Nunca fazer commit de passwords, ficheiros de ligação do SQL Developer ou dados pessoais

## 8. Como o Claude deve ajudar

- Segue sempre o **método da secção 0**: código na conversa, um passo de cada vez, avançar só depois de "feito"
- O aluno tem de **perceber e conseguir explicar** todo o código entregue. Explica o porquê das decisões
- Segue o **estilo dos slides do professor** (ver exemplos em `cap23` e fichas)
- Antes de dar código, confirma que só usa elementos da secção 4
- Quando houver ambiguidade no enunciado, aponta-a e sugere registá-la como comentário no `.sql` (ex. `-- Assumimos que ...`)
- Lembra o aluno de **correr no SQL Developer** e colar o output/erro, em vez de assumires que funciona
- Se uma decisão afetar outra pessoa (nome de tabela, assinatura de função, formato de dados), diz isso explicitamente e sugere avisar o grupo
- Respeita os prazos de `planos/<Nome>.md`; se o aluno estiver atrasado, ajuda a priorizar o essencial
