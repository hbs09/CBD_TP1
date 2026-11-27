-- EX 2a
-- Mantém PROCEDIMENTO.total_contratos atualizado (INSERT, DELETE e UPDATE)

SET SERVEROUTPUT ON;

-- INSERT
CREATE OR REPLACE TRIGGER ActualizaTotalContratos
AFTER INSERT ON CONTRATO
FOR EACH ROW
BEGIN 
    UPDATE PROCEDIMENTO
    SET total_contratos = total_contratos + 1
    WHERE id_procedimento = :NEW.id_procedimento;
END;
/

-- DELETE
CREATE OR REPLACE TRIGGER ActualizaTotalContratos_DEL
AFTER DELETE ON CONTRATO
FOR EACH ROW
BEGIN
    UPDATE PROCEDIMENTO
    SET total_contratos = total_contratos - 1
    WHERE id_procedimento = :OLD.id_procedimento;
END;
/

-- UPDATE
CREATE OR REPLACE TRIGGER ActualizaTotalContratos_UPD
AFTER UPDATE OF id_procedimento ON CONTRATO
FOR EACH ROW
WHEN (OLD.id_procedimento <> NEW.id_procedimento)
BEGIN
    UPDATE PROCEDIMENTO
    SET total_contratos = total_contratos - 1
    WHERE id_procedimento = :OLD.id_procedimento;
    
    UPDATE PROCEDIMENTO
    SET total_contratos = total_contratos + 1
    WHERE id_procedimento = :NEW.id_procedimento;
END;
/


-- TESTES

-- Procedimentos 6716930 e 7074903 (Ambos com 1)
SELECT id_procedimento, total_contratos FROM PROCEDIMENTO
WHERE id_procedimento IN (6716930, 7074903);

-- INSERT no 6716930 (esperado: 2 e 1)
INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto,
                      data_publicacao, preco_contratual, prazo_execucao)
VALUES (99999999, 6716930, 'Contrato de teste 2a', SYSDATE, 1000, 30);

SELECT id_procedimento, total_contratos FROM PROCEDIMENTO
WHERE id_procedimento IN (6716930, 7074903);

-- UPDATE para 7074903 (esperado: 1 e 2)
UPDATE CONTRATO SET id_procedimento = 7074903 WHERE id_contrato = 99999999;

SELECT id_procedimento, total_contratos FROM PROCEDIMENTO
WHERE id_procedimento IN (6716930, 7074903);

-- UPDATE para o mesmo procedimento (esperado: sem alteração, 1 e 2)
UPDATE CONTRATO SET id_procedimento = 7074903 WHERE id_contrato = 99999999;

SELECT id_procedimento, total_contratos FROM PROCEDIMENTO
WHERE id_procedimento IN (6716930, 7074903);

-- UPDATE de outra coluna (esperado: sem alteração, 1 e 2)
UPDATE CONTRATO SET objeto = 'Teste alterado' WHERE id_contrato = 99999999;

SELECT id_procedimento, total_contratos FROM PROCEDIMENTO
WHERE id_procedimento IN (6716930, 7074903);

-- DELETE (esperado: 1 e 1)
DELETE FROM CONTRATO WHERE id_contrato = 99999999;

SELECT id_procedimento, total_contratos FROM PROCEDIMENTO
WHERE id_procedimento IN (6716930, 7074903);

ROLLBACK;









