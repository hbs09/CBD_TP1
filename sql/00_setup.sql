DROP TABLE REGISTA_ALTERACOES_PRECOS CASCADE CONSTRAINTS;
DROP TABLE RESULTADO_LOCALIZACAO CASCADE CONSTRAINTS;
DROP TABLE CONTRATO CASCADE CONSTRAINTS;
DROP TABLE PROCEDIMENTO CASCADE CONSTRAINTS;


-- 1. CÓPIA DE PROCEDIMENTO (+ PK, que o AS SELECT não copia)
CREATE TABLE PROCEDIMENTO AS
    SELECT * FROM C##_TP1_2627.PROCEDIMENTO;

ALTER TABLE PROCEDIMENTO
    ADD CONSTRAINT PK_PROCEDIMENTO PRIMARY KEY (id_procedimento);
    

-- 2. CÓPIA DE CONTRATO (+ PK e FK para PROCEDIMENTO)
CREATE TABLE CONTRATO AS
    SELECT * FROM C##_TP1_2627.CONTRATO;

ALTER TABLE CONTRATO
    ADD CONSTRAINT PK_CONTRATO PRIMARY KEY (id_contrato);

ALTER TABLE CONTRATO
    ADD CONSTRAINT FK_CONTRATO_PROCEDIMENTO
    FOREIGN KEY (id_procedimento) REFERENCES PROCEDIMENTO (id_procedimento);
    
    

-- 3. TOTAL_CONTRATOS (Ex. 2a) — criar e inicializar com a contagem real
ALTER TABLE PROCEDIMENTO
    ADD total_contratos NUMBER DEFAULT 0 NOT NULL;

UPDATE PROCEDIMENTO p
SET total_contratos = (SELECT COUNT(*)
                       FROM CONTRATO c
                       WHERE c.id_procedimento = p.id_procedimento);

COMMIT;    

-- 4. RESULTADO_LOCALIZACAO (Ex. 1b) — resultados da Procura_Contratos_Concelho
CREATE TABLE RESULTADO_LOCALIZACAO (
    id_contrato      NUMBER(38),
    objeto           VARCHAR2(2048),
    pais             VARCHAR2(100),
    distrito         VARCHAR2(100),
    concelho         VARCHAR2(100),
    preco_contratual NUMBER(38,2)
);
    
    
-- 5. REGISTA_ALTERACOES_PRECOS (Ex. 2b) — auditoria de preços
-- novo_preco aceita NULL: o DELETE regista NULL
CREATE TABLE REGISTA_ALTERACOES_PRECOS (
    id_contrato    NUMBER(38)     NOT NULL,
    objeto         VARCHAR2(2048) NOT NULL,
    preco_antigo   NUMBER(38,2)   NOT NULL,
    novo_preco     NUMBER(38,2),
    data_alteracao DATE           NOT NULL
);


-- TESTES
-- Cópias com o mesmo nº de linhas que as originais (esperado: iguais)
SELECT (SELECT COUNT(*) FROM CONTRATO)                  AS contrato_copia,
       (SELECT COUNT(*) FROM C##_TP1_2627.CONTRATO)     AS contrato_original,
       (SELECT COUNT(*) FROM PROCEDIMENTO)              AS proc_copia,
       (SELECT COUNT(*) FROM C##_TP1_2627.PROCEDIMENTO) AS proc_original
FROM DUAL;

-- Soma dos totais = nº de contratos (esperado: 4999)
SELECT SUM(total_contratos) AS soma_totais FROM PROCEDIMENTO;

-- Tabelas criadas (esperado: 4)
SELECT table_name FROM USER_TABLES
WHERE table_name IN ('CONTRATO', 'PROCEDIMENTO',
                     'RESULTADO_LOCALIZACAO', 'REGISTA_ALTERACOES_PRECOS');
