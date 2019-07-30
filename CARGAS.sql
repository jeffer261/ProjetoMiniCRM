--CARGAS TABELAS USUARIO

	INSERT INTO USUARIOS
	SELECT A.LOGIN,
		   A.MATRICULA,
		   A.SENHA,
		   A.SITUACAO,
		   SUBSTRING(C.NOME_CARGO,1,1) TIPO
	FROM MINIERP.DBO.USUARIOS A
	INNER JOIN MINIERP.DBO.FUNCIONARIO B
	ON A.MATRICULA=B.MATRICULA
	INNER JOIN MINIERP.DBO.CARGOS C
	ON B.COD_CARGO=C.COD_CARGO
	WHERE B.COD_CARGO IN (2,3) --2 -GER COMERCIAL 3- VENDEDOR

--CARGA DE AGENDAS
INSERT INTO AGENDA VALUES
    (8,2,'2017-01-15','09:00:00','10:00:00','P','TESTE 1',GETDATE()),
    (8,2,'2017-02-15','09:00:00','10:00:00','P','TESTE 2',GETDATE()),
	(8,2,'2017-03-15','09:00:00','10:00:00','P','TESTE 3',GETDATE()),
	(8,2,'2017-04-15','09:00:00','10:00:00','P','TESTE 4',GETDATE()),
	(8,2,'2017-05-15','09:00:00','10:00:00','P','TESTE 5',GETDATE()),
	(8,2,'2017-06-15','09:00:00','10:00:00','P','TESTE 6',GETDATE()),
	(8,2,'2017-07-15','09:00:00','10:00:00','P','TESTE 7',GETDATE()),
	(8,2,'2017-08-15','09:00:00','10:00:00','P','TESTE 8',GETDATE()),
    (8,2,'2017-09-15','09:00:00','10:00:00','P','TESTE 9',GETDATE()),
	(8,2,'2017-10-15','09:00:00','10:00:00','P','TESTE 10',GETDATE()),
	(8,2,'2017-11-15','09:00:00','10:00:00','P','TESTE 11',GETDATE()),
	(8,2,'2017-12-15','09:00:00','10:00:00','P','TESTE 12',GETDATE())
   
INSERT INTO AGENDA VALUES
    (9,3,'2017-01-15','09:00:00','10:00:00','P','TESTE 1',GETDATE()),
    (9,3,'2017-02-15','09:00:00','10:00:00','P','TESTE 2',GETDATE()),
	(9,3,'2017-03-15','09:00:00','10:00:00','P','TESTE 3',GETDATE()),
	(9,3,'2017-04-15','09:00:00','10:00:00','P','TESTE 4',GETDATE()),
	(9,3,'2017-05-15','09:00:00','10:00:00','P','TESTE 5',GETDATE()),
	(9,3,'2017-06-15','09:00:00','10:00:00','P','TESTE 6',GETDATE()),
	(9,3,'2017-07-15','09:00:00','10:00:00','P','TESTE 7',GETDATE()),
	(9,3,'2017-08-15','09:00:00','10:00:00','P','TESTE 8',GETDATE()),
    (9,3,'2017-09-15','09:00:00','10:00:00','P','TESTE 9',GETDATE()),
	(9,3,'2017-10-15','09:00:00','10:00:00','P','TESTE 10',GETDATE()),
	(9,3,'2017-11-15','09:00:00','10:00:00','P','TESTE 11',GETDATE()),
	(9,3,'2017-12-15','09:00:00','10:00:00','P','TESTE 12',GETDATE())

INSERT INTO AGENDA VALUES
    (9,4,'2017-01-15','09:00:00','10:00:00','P','TESTE 1',GETDATE()),
    (9,4,'2017-02-15','09:00:00','10:00:00','P','TESTE 2',GETDATE()),
	(9,4,'2017-03-15','09:00:00','10:00:00','P','TESTE 3',GETDATE()),
	(9,4,'2017-04-15','09:00:00','10:00:00','P','TESTE 4',GETDATE()),
	(9,4,'2017-05-15','09:00:00','10:00:00','P','TESTE 5',GETDATE()),
	(9,4,'2017-06-15','09:00:00','10:00:00','P','TESTE 6',GETDATE()),
	(9,4,'2017-07-15','09:00:00','10:00:00','P','TESTE 7',GETDATE()),
	(9,4,'2017-08-15','09:00:00','10:00:00','P','TESTE 8',GETDATE()),
    (9,4,'2017-09-15','09:00:00','10:00:00','P','TESTE 9',GETDATE()),
	(9,4,'2017-10-15','09:00:00','10:00:00','P','TESTE 10',GETDATE()),
	(9,4,'2017-11-15','09:00:00','10:00:00','P','TESTE 11',GETDATE()),
	(9,4,'2017-12-15','09:00:00','10:00:00','P','TESTE 12',GETDATE())

--SELECT * FROM FOLLOW_UP_AGENDA
--CARGA DE FOLLOW_UP DE AGENDA
INSERT INTO FOLLOW_UP_AGENDA
SELECT ID_AGENDA,
CASE WHEN ID_AGENDA%2<>0 THEN 'S' ELSE 'N' END GERA_VENDA,
'TESTE DE OBS...' OBS
FROM  AGENDA

GO

--CREATE VIEW AGENDAS
--CREATE VIEW AGENDAS_DETALHE
CREATE VIEW V_CRM_AGENDAS_DETALHE
 AS
  SELECT A.ID_AGENDA,
         A.MATRICULA,
		 C.NOME_VEND,
		 A.ID_CLIENTE,
		 C.RAZAO_CLIENTE,
         A.DATA_VISITA,
		 A.SITUACAO,
         B.GEROU_VENDA
   FROM AGENDA A
   INNER JOIN FOLLOW_UP_AGENDA B
   ON A.ID_AGENDA=B.ID_AGENDA
   INNER JOIN V_CRM_CANAL_VENDAS C
   ON A.ID_CLIENTE=C.ID_CLIENTE

GO
--CREATE VIEW AGENDAS RESUMO
CREATE VIEW V_CRM_AGENDAS_RESUMO
AS
   SELECT 
         A.MATRICULA,
		 C.NOME_VEND,
		 A.ID_CLIENTE,
		 C.RAZAO_CLIENTE,
		 A.SITUACAO,
		 COUNT(*) QTD_VISITAS,
         B.GEROU_VENDA
   FROM AGENDA A
   INNER JOIN FOLLOW_UP_AGENDA B
   ON A.ID_AGENDA=B.ID_AGENDA
   INNER JOIN V_CRM_CANAL_VENDAS C
   ON A.ID_CLIENTE=C.ID_CLIENTE
   GROUP BY  A.MATRICULA,
		 C.NOME_VEND,
		 A.ID_CLIENTE,
		 C.RAZAO_CLIENTE,
		 A.SITUACAO,B.GEROU_VENDA




