# CBD_TP1 — Complementos de Bases de Dados

Trabalho Prático 1 · PL/SQL sobre contratos públicos portugueses (2026)

- **Entrega:** Moodle, até **4/dez às 23:59**
- **Prazo interno do grupo:** **2/dez** — tudo no repositório e testado
- **Enunciado:** [`enunciado/TP1_CBD_FREQ.pdf`](enunciado/TP1_CBD_FREQ.pdf)
- **Dicionário de dados:** [`enunciado/Dicionario_Dados_Contratos.pdf`](enunciado/Dicionario_Dados_Contratos.pdf)
- **Base de dados (só leitura):** `C##_TP1_2627.<tabela>`

---

## Divisão de tarefas

| Quem | Tarefas | Ficheiros | Plano |
|---|---|---|---|
| **Henrique** (organizador) | Setup + Ex. 2a + Ex. 3b (trigger) + junção final | `00_setup.sql`, `02a_trigger_total.sql`, `03b_trigger_grupo.sql` | [planos/Henrique.md](planos/Henrique.md) |
| **David** | Ex. 1a + Ex. 1b | `01a_resumo_entidade.sql`, `01b_procura_contratos.sql` | [planos/David.md](planos/David.md) |
| **Eduardo** | Ex. 2b + Ex. 3a (pacote/procedimento/função) | `02b_trigger_auditoria.sql`, `03a_pacote_grupo.sql` | [planos/Eduardo.md](planos/Eduardo.md) |

Peso estimado (1–5): setup 1 · 1a 3 · 1b 4 · 2a 2 · 2b 2 · 3a 4 · 3b 3 → cada pessoa fica com ~6–7.

**Em conjunto:**
- A **ideia do Ex. 3** é decidida pelos três (até 26/nov)
- **Henrique + Eduardo** desenham juntos as tabelas extra do Ex. 3 (o Henrique acrescenta-as ao `00_setup.sql`)
- **Revisão cruzada:** Henrique revê David · David revê Eduardo · Eduardo revê Henrique

---

## Calendário

| Data | Henrique | David | Eduardo |
|---|---|---|---|
| **Ter 24/nov** | Setup | Estudar o modelo, começar 1a | Estudar o modelo e triggers |
| **Qua 25/nov** | **Setup no repo** ✅ | 1a | Correr setup, começar 2b |
| **Qui 26/nov** | 2a | 1a | 2b · 🗳️ **Reunião: ideia do Ex. 3** (os três) |
| **Sex 27/nov** | 2a ✅ | **1a ✅**, começar 1b | **2b ✅** |
| **Sáb 28/nov** | Tabelas do Ex. 3 (com Eduardo) | 1b | Tabelas do Ex. 3 (com Henrique) |
| **Dom 29/nov** | 3b | 1b | 3a |
| **Seg 30/nov** | 3b ✅ | **1b ✅** | 3a |
| **Ter 1/dez** (feriado) | Revê David | Revê Eduardo | **3a ✅** · Revê Henrique |
| **Qua 2/dez** | **Junção + teste completo** | Correções | Correções · explicação do Ex. 3 |
| **Qui 3/dez** | Folga para imprevistos | | |
| **Sex 4/dez** | **Entregar no Moodle (de manhã, não às 23:58)** | | |

---

## Tarefas

### Setup · Henrique
- [ ] `DROP` de todas as tabelas criadas pelo grupo (o script tem de poder correr várias vezes)
- [ ] Copiar `CONTRATO` e `PROCEDIMENTO` de `C##_TP1_2627` (`CREATE TABLE ... AS SELECT`)
- [ ] Recriar PK e FK nas cópias (o `CREATE TABLE AS SELECT` só copia `NOT NULL`)
- [ ] Adicionar `total_contratos` a `PROCEDIMENTO` e inicializar com a contagem real
- [ ] Criar `RESULTADO_LOCALIZACAO (id_contrato, objeto, pais, distrito, concelho, preco_contratual)`
- [ ] Criar `REGISTA_ALTERACOES_PRECOS (id_contrato, objeto, preco_antigo, novo_preco, data_alteracao)`
- [ ] (mais tarde) Tabelas extra do Ex. 3

### Ex. 1a — Procedimento `Resumo_Entidade` · David
- [ ] Pesquisa por parte do nome com `INSTR`, ignorando maiúsculas/minúsculas
- [ ] Por entidade: ID, designação, identificador fiscal
- [ ] Total de contratos distintos
- [ ] Nº e valor total de contratos como **adjudicante**
- [ ] Nº e valor total de contratos como **adjudicatário**
- [ ] Mensagem quando não encontra entidades
- [ ] Output formatado como no exemplo (`637.252,34`)
- [ ] Testes

### Ex. 1b — Função `Procura_Contratos_Concelho` · David
- [ ] Separar `LOCAL_EXECUCAO.descricao` ("Portugal, Distrito, Concelho")
- [ ] Limpar `RESULTADO_LOCALIZACAO` antes de inserir
- [ ] Inserir os contratos do distrito/concelho pedido
- [ ] Retornar `0` se registou contratos, `1` se não encontrou ou ocorreu erro
- [ ] Testes

### Ex. 2a — Trigger `ActualizaTotalContratos` · Henrique
- [ ] `INSERT` → +1 · `DELETE` → −1 · `UPDATE` de `id_procedimento` → −1 antigo, +1 novo
- [ ] Testes

### Ex. 2b — Trigger `AuditaPrecosContratos` · Eduardo
- [ ] `UPDATE`: registar só se o preço mudar mesmo (atenção a `NULL`)
- [ ] `DELETE`: registar com `novo_preco = NULL`
- [ ] Testes

### Ex. 3 — Proposta do grupo · Eduardo (3a) + Henrique (3b)
- [ ] Decidir a ideia (os três)
- [ ] Tabelas extra (Henrique + Eduardo)
- [ ] a) Pacote / procedimento / função — Eduardo
- [ ] b) Trigger — Henrique
- [ ] Testes
- [ ] Explicação resumida de cada proposta (em comentário no `.sql`)

### Final — todos
- [ ] Revisão cruzada (1/dez)
- [ ] Juntar tudo num único `.sql`, pela ordem: setup → 1a → 1b → 2a → 2b → 3a → 3b
- [ ] Correr o ficheiro final de ponta a ponta num utilizador limpo
- [ ] Nome: `TP1_HenriqueNum_DavidNum_EduardoNum_INF.sql` (ou `_IM.sql`) — trocar `Num` pelos números de aluno
- [ ] Entregar no Moodle

---

## Regras do enunciado a não esquecer
- Só contam elementos de PL/SQL dados nas aulas — **outros não são considerados**
- O `.sql` entregue tem de incluir criação/remoção de tabelas, os dados de teste e o código de teste
- No Ex. 3, explicar resumidamente o que se pretende com cada proposta
- Requer nota mínima na componente teórico-prática

## Convenções do grupo
- Cada ficheiro começa com um cabeçalho: exercício, autor, descrição
- Testes no fim de cada ficheiro, numa secção `-- TESTES`, com comentário do resultado esperado
- `SET SERVEROUTPUT ON` no início de cada ficheiro que usa `DBMS_OUTPUT`
- Ex. 1 lê de `C##_TP1_2627.<tabela>`; Ex. 2 e 3 escrevem nas **cópias** criadas pelo setup
- Quando tiverem dúvidas sobre o que é "dado nas aulas", ver as fichas `CBD_pcap21` a `CBD_pcap24`

---

## Estrutura do repositório

```
CBD_TP1/
├── README.md
├── CLAUDE.md                      regras partilhadas para os assistentes (Claude)
├── contexto/                      contexto de cada pessoa para o seu Claude
├── planos/                        plano de cada pessoa
├── enunciado/                     PDFs do enunciado e dicionário de dados
├── sql/
│   ├── 00_setup.sql               Henrique
│   ├── 01a_resumo_entidade.sql    David
│   ├── 01b_procura_contratos.sql  David
│   ├── 02a_trigger_total.sql      Henrique
│   ├── 02b_trigger_auditoria.sql  Eduardo
│   ├── 03a_pacote_grupo.sql       Eduardo
│   └── 03b_trigger_grupo.sql      Henrique
└── entrega/                       ficheiro final para o Moodle
```

## Usar o Claude no trabalho

Para os três Claudes seguirem as mesmas regras (professor, PL/SQL permitido, convenções, commits):

- **Claude Code** (na pasta do repositório): o `CLAUDE.md` é lido automaticamente. No início, diz-lhe *"Sou o David, lê `contexto/David.md` e `planos/David.md`"*.
- **claude.ai** (chat): cria um Projeto e adiciona `CLAUDE.md`, `contexto/<Nome>.md`, `planos/<Nome>.md` e os dois PDFs do enunciado.

Quando o `CLAUDE.md` ou o teu `contexto/` mudar, atualiza-o no teu Projeto.

**Mensagens de commit:** `[ex] tipo: descrição` — ex. `[1a] feat: cursor de entidades com INSTR`. Tipos: `feat`, `fix`, `test`, `refactor`, `docs` (detalhes no `CLAUDE.md`, secção 7).

## Como trabalhar (GitHub Desktop + SQL Developer)

1. **Fetch / Pull origin** no GitHub Desktop antes de começar
2. Abrir o teu ficheiro no SQL Developer (**File → Open**), editar, correr, **Ctrl+S**
3. No GitHub Desktop: escrever mensagem → **Commit to main** → **Push origin**

**Regras:**
- Cada pessoa só edita os **seus** ficheiros — assim não há conflitos
- O Git não sincroniza a base de dados: depois de um pull, corre no SQL Developer o código novo para ele existir no teu utilizador Oracle
- Cada pessoa corre o `00_setup.sql` no seu utilizador (e volta a correr quando o setup mudar)
- Nunca guardar passwords nos ficheiros
