# Primeiros passos — ler antes de começar

Guia para pôr tudo a funcionar no teu computador: repositório, SQL Developer, onde estão as tabelas e como correr o código.

---

## 1. Ter o repositório no computador (uma vez)

1. Aceitar o convite do Henrique para o repositório `hbs09/CBD_TP1` (chega por email / notificação no GitHub)
2. Instalar o [GitHub Desktop](https://desktop.github.com) e entrar com a tua conta GitHub
3. **File → Clone repository** → escolher `CBD_TP1` → escolher uma pasta **vazia** → **Clone**
4. Ler o [README](README.md), o teu plano em [`planos/`](planos/) e o teu contexto em [`contexto/`](contexto/)

---

## 2. Criar a ligação certa no SQL Developer (uma vez)

⚠️ A BD do TP1 está no servidor **`bds0`** — ligações ao `bds1` não a veem.

**File → New → Database Connection** (ou o **+** verde no painel Connections):

| Campo | Valor |
|---|---|
| Name | à escolha (ex. `tp1_cbd`) |
| Username | a tua conta: `C##_INF_<número>` ou `C##_IM_<número>` |
| Password | a tua password (marca **Save Password**) |
| Hostname | `bds0.est.ipcb.pt` |
| Port | `1521` |
| SID | `xe` |

**Test** → **Save** → **Connect**.

**Confirmar que é a ligação certa** — numa folha SQL dessa ligação, **Ctrl+Enter**:
```sql
SELECT COUNT(*) FROM C##_TP1_2627.CONTRATO;
```
Tem de dar **4999**. Se der **ORA-00942** (tabela não existe), estás no servidor errado.

> Não vês o painel **Connections**? Menu **View → Connections**.

---

## 3. Onde estão as tabelas

A base de dados do professor está no utilizador **`C##_TP1_2627`** e é **só de leitura** (podes consultar, não podes alterar).

### Pela árvore (para explorar)
1. No SQL Developer, painel **Connections** (à esquerda) → abre a tua ligação habitual
2. Desce até **Other Users** → abre
3. Procura **C##_TP1_2627** → **Tables**
4. Clica numa tabela → separadores **Columns** (colunas e tipos) e **Data** (dados)

> Lista muito grande? Botão direito em **Other Users** → **Apply Filter** → escreve `C##_TP1%`

### Por consultas (o mais prático)
Numa folha SQL (**Alt+F10** ou o ícone **SQL Worksheet**):

```sql
-- colunas e tipos de uma tabela
DESC C##_TP1_2627.CONTRATO;

-- ver alguns registos
SELECT * FROM C##_TP1_2627.CONTRATO FETCH FIRST 20 ROWS ONLY;

-- quantos registos tem
SELECT COUNT(*) FROM C##_TP1_2627.CONTRATO;
```

As 13 tabelas: `CONTRATO`, `PROCEDIMENTO`, `TIPO_PROCEDIMENTO`, `ENTIDADE`, `CONTRATO_ENTIDADE`, `LOCAL_EXECUCAO`, `CONTRATO_LOCAL_EXECUCAO`, `CPV`, `CONTRATO_CPV`, `TIPO_CONTRATO`, `CONTRATO_TIPO_CONTRATO`, `NUTS`, `PAIS`.
O significado de cada coluna está no [dicionário de dados](enunciado/Dicionario_Dados_Contratos.pdf).

### As tabelas de leitura vs. as nossas cópias

| | Onde | Para quê |
|---|---|---|
| `C##_TP1_2627.CONTRATO` (do professor) | **Other Users → C##_TP1_2627 → Tables** | Ler dados (Ex. 1) |
| `CONTRATO` (cópia nossa) | **A tua ligação → Tables** | Triggers e alterações (Ex. 2 e 3) |

As cópias só aparecem **depois de correres o `00_setup.sql`** (ver ponto 5). Depois de correr, clica no botão de **refresh** (seta circular) em **Tables**.

---

## 4. Como correr código no SQL Developer

| Tecla | O que faz | Quando usar |
|---|---|---|
| **Ctrl+Enter** | Corre **só a instrução** onde está o cursor | Testar uma consulta, um `DESC` |
| **F5** (Run Script) | Corre o **ficheiro inteiro**, de cima a baixo | Correr o setup, criar procedimentos/triggers, ficheiros com vários blocos |

- Procedimentos, funções, pacotes, triggers e blocos `BEGIN ... END;` terminam com **`/`** numa linha sozinha — sem isso o F5 não os executa
- Erros de compilação: o SQL Developer diz *"compilado com erros"* → corre `SHOW ERRORS;` para ver quais

### Ver o output do `DBMS_OUTPUT.PUT_LINE`
- Pôr **`SET SERVEROUTPUT ON;`** no início do ficheiro (já faz parte do cabeçalho combinado)
- O texto aparece no separador **Script Output** (com F5)
- Alternativa: **View → Dbms Output** → botão **+** → escolher a tua ligação

---

## 5. Correr o setup (uma vez, e de novo quando mudar)

1. GitHub Desktop → **Fetch origin** / **Pull origin**
2. No SQL Developer: **File → Open** → `sql/00_setup.sql`
3. Escolher a tua ligação (canto superior direito da folha)
4. **F5**
5. Os `DROP` dão erro **ORA-00942** na 1.ª vez — é normal (as tabelas ainda não existiam)
6. Refresh em **Tables** da tua ligação → devem aparecer `CONTRATO`, `PROCEDIMENTO`, `RESULTADO_LOCALIZACAO`, `REGISTA_ALTERACOES_PRECOS`

**Quando voltar a correr:** sempre que um pull trouxer alterações ao `00_setup.sql`.
⚠️ Correr o setup **apaga e recria** as cópias — os teus triggers do Ex. 2/3 também são apagados, por isso corre depois outra vez os teus ficheiros.

---

## 6. Rotina de cada sessão de trabalho

1. **GitHub Desktop → Fetch origin / Pull origin**
2. Se o setup mudou → correr o setup (ponto 5)
3. Abrir o **teu** ficheiro no SQL Developer
4. Trabalhar com o Claude (ele envia o código passo a passo; tu copias; dizes **"feito"**)
5. **Ctrl+S** → GitHub Desktop → **Commit to main** → **Push origin**

Dúvidas de Git? O teu Claude sabe guiar-te (está no `CLAUDE.md`, secção 7).
