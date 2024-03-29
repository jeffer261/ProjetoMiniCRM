--USE MASTER
--DROP  DATABASE MINICRM
CREATE DATABASE MINICRM
GO
USE MINICRM
GO
--CRIANDO TABELAS DE USUARIOS
--DROP TABLE USUARIOS
CREATE TABLE USUARIOS
	(
	LOGIN VARCHAR(30) NOT NULL,
	MATRICULA INT NOT NULL,
	SENHA   VARCHAR(32) NOT NULL,
	SITUACAO CHAR(1) NOT NULL, --A=ATIVO -B BLOQUEADO
	TIPO VARCHAR(20),
	CONSTRAINT PK_US1 PRIMARY KEY (LOGIN)
	)
--CRIANDO TABELA DE AGENDA

CREATE TABLE AGENDA
 (
  ID_AGENDA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  MATRICULA INT NOT NULL,
  ID_CLIENTE INT NOT NULL,
  DATA_VISITA DATE,
  HORA_VISITA_DE TIME,
  HORA_VISITA_ATE TIME,
  SITUACAO CHAR(1) NOT NULL, --P-PLANEJADA R-REALIZADA -C-CANCELADA
  OBS VARCHAR(255),
  DATA_LOG DATETIME NOT NULL
  )
--CRIACAO DA TABELAS DO FOLLOW UP DA AGENDA
CREATE TABLE FOLLOW_UP_AGENDA
(
  ID_AGENDA INT NOT NULL,
  GEROU_VENDA CHAR(1)NOT NULL, --S/N
  OBS_POS_VISITA VARCHAR(255) NOT NULL,
  CONSTRAINT FK_FUP1 FOREIGN KEY (ID_AGENDA) REFERENCES AGENDA(ID_AGENDA)
)

GO

--VIEW CANAL DE VENDAS
CREATE VIEW V_CRM_CANAL_VENDAS
AS
SELECT * FROM MINIERP.DBO.V_CANAL_VENDAS

GO
--VIEW CONTAS A PAGAR
CREATE VIEW V_CRM_CONTAS_RECEBER
AS
SELECT * FROM MINIERP.DBO.V_CONTAS_RECEBER

GO
--VIEW PEDIDO  VENDAS DETALHE
CREATE VIEW V_CRM_PED_VENDAS_DETALHE
AS
SELECT A.NUM_PEDIDO,A.DATA_PEDIDO,
       A.ID_CLIENTE,B.RAZAO_CLIENTE,
 A.TOTAL_PED,A.SITUACAO,
CASE WHEN A.SITUACAO='F' THEN 'FATURADO'
     WHEN A.SITUACAO='P' THEN 'PLANEJADO'
	 END SITUA
 FROM MINIERP.DBO.PED_VENDAS A
 INNER JOIN MINIERP.DBO.CLIENTES B
 ON A.ID_CLIENTE=B.ID_CLIENTE

GO
--VIEW FATURAMENTO DETALHE
CREATE VIEW V_CRM_FAT_DETALHE
AS
SELECT * FROM MINIERP.DBO.V_FATURAMENTO

GO
---VIEW FATURAMENTO RESUMO
CREATE VIEW V_CRM_FAT_RESUMO
AS
SELECT A.ID_CLIFOR,A.RAZAO_CLIENTE,
       MONTH(A.DATA_EMISSAO) MES,
       YEAR(A.DATA_EMISSAO) ANO,
	   SUM(A.TOTAL) TOTAL
	   FROM MINIERP.DBO.V_FATURAMENTO A
	   GROUP BY A.ID_CLIFOR,A.RAZAO_CLIENTE,MONTH(A.DATA_EMISSAO),YEAR(A.DATA_EMISSAO)

GO
--CRIACAO DE VIEW META X REALIZADO 2017
--VERIFICANDO TABELAS DE METAS
-- SELECT * FROM MINIERP.DBO.META_VENDAS A
 --ATUALIZANDO VALORES
-- UPDATE MINIERP.DBO.META_VENDAS  SET VALOR=VALOR*10000

--SELECT * FROM V_CRM_CANAL_VENDAS
GO
CREATE VIEW V_CRM_META_2017
AS
SELECT A.ID_VEND,
       B.NOME_VEND,
	   A.ANO,
	   A.MES,
	   A.VALOR META,
	   SUM(ISNULL(C.TOTAL,0))REALIZ,
       CAST(100/A.VALOR*SUM(ISNULL(C.TOTAL,0)) AS DECIMAL(10,2))PCT
  FROM MINIERP.DBO.META_VENDAS A
  LEFT JOIN V_CRM_CANAL_VENDAS B
  ON A.ID_VEND=B.ID_VEND
  LEFT JOIN  V_CRM_FAT_RESUMO C
  ON B.ID_CLIENTE=C.ID_CLIFOR
  AND A.MES=C.MES
  AND A.ANO=C.ANO
  WHERE A.ANO=2017
  GROUP BY  A.ID_VEND,
       B.NOME_VEND,
	   A.ANO,
	   A.MES,
	   A.VALOR,
	   100/A.VALOR
