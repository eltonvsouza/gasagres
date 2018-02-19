--CONSULTA � TABELA APOSENTADOS
select
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF', -- N� do CPF do servidor
CASE WHEN RTRIM(LTRIM(f.cod_clasf)) = '' THEN
	'9999' ELSE 
	ISNULL(CAST(substring(f.cod_clasf,2,4) AS VARCHAR), '9999') END 'CARGO', -- C�digo de identifica��o do cargo
substring(RTRIM(LTRIM(CAST(f.matr AS VARCHAR))),1,15) 'MATR�CULA', -- N�mero da Matr�cula
:mesAno 'MES/ANO', -- M�s e ano de refer�ncia
CASE WHEN e.V_D_EVEN = 'V' THEN 0 ELSE 1 END '0 � V | 1 - D',  -- C�digo da opera��o
'1' + CAST(aa.COD_EVE AS VARCHAR) 'COD_V_D', -- C�digo da vantagem ou desconto
'0' 'TIPO FOLHA',-- Tipo de folha (0 � Normal | 1 � 13� Sal. | 2 � F. Extra | 3 � F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- C�digo do agrupamento da Folha
-- RH_TESTE (inativos)
from funcionarios f,
	apost_fichas aa,
	eventos e,
	func_apost fa
WHERE	aa.mat_apost = f.matr
	AND aa.cod_eve = e.cod_even
	AND aa.mes_ano = :mesAno
	AND fa.matr_apost = aa.mat_apost
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND RTRIM(LTRIM(f.cod_clasf)) <> ''
--	AND f.dt_adm >= dat_nasc
--	AND f.cpf <> '10890165491'
--	AND f.cpf <> '02328330444'
GROUP BY f.matr, f.cpf, f.cod_clasf, e.v_d_even, aa.cod_eve, aa.val_tot

UNION

--CONSULTA � TABELA DE DECIMO TERCEIRO DOS APOSENTADOS
SELECT
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF', -- N� do CPF do servidor
CASE WHEN RTRIM(LTRIM(f.cod_clasf)) = '' THEN
	'9999' ELSE 
	ISNULL(CAST(substring(f.cod_clasf,2,4) AS VARCHAR), '9999') END 'CARGO', -- C�digo de identifica��o do cargo
substring(RTRIM(LTRIM(CAST(f.matr AS VARCHAR))),1,15) 'MATR�CULA', -- N�mero da Matr�cula
:mesAno 'MES/ANO', -- M�s e ano de refer�ncia
CASE WHEN e.V_D_EVEN = 'V' THEN 0 ELSE 1 END '0 � V | 1 - D',  -- C�digo da opera��o
'1' + CAST(aa.COD_EVE AS VARCHAR) 'COD_V_D', -- C�digo da vantagem ou desconto
'1' 'TIPO FOLHA',-- Tipo de folha (0 � Normal | 1 � 13� Sal. | 2 � F. Extra | 3 � F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- C�digo do agrupamento da Folha
-- RH_TESTE (inativos)
FROM funcionarios f,
	apost_fichas_temp13 aa,
	eventos e, func_apost fa
WHERE	aa.matr_apost = f.matr
	AND aa.cod_eve = e.cod_even
	AND fa.matr_apost = aa.matr_apost
	AND tipo_13sal = :tipo13Sal
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND RTRIM(LTRIM(f.cod_clasf)) <> ''
--	AND f.dt_adm >= dat_nasc
--	AND f.cpf <> '10890165491'
--	AND f.cpf <> '02328330444'
GROUP BY f.matr, f.cpf, f.cod_clasf, e.v_d_even, aa.cod_eve, aa.val_tot

UNION

-- CONSULTA � TABELA ATIVOS
select 
-- Tratamento para n�o listar CPF menor que 11 d�gitos
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF', -- N� do CPF do servidor
isnull(CAST(substring(f.cod_clasf,2,4) AS VARCHAR), '9999') 'CARGO', -- C�digo do cargo ou fun��o
substring(RTRIM(LTRIM(CAST(f.matr AS VARCHAR))),1,15) 'MATR�CULA', -- N�mero da Matr�cula
:mesAno 'MES/ANO', -- M�s e ano de refer�ncia
CASE WHEN e.V_D_EVEN = 'V' THEN 0 ELSE 1 END '0 � V | 1 - D',  -- C�digo da opera��o
'1' + CAST(aa.COD_EVE AS VARCHAR) 'COD_V_D', -- C�digo da vantagem ou desconto
'0' 'TIPO FOLHA',-- Tipo de folha (0 � Normal | 1 � 13� Sal. | 2 � F. Extra | 3 � F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- C�digo do agrupamento da Folha
-- RH_TESTE (inativos)
from funcionarios f,
	ficha_finan aa,
	eventos e
WHERE	aa.mat_past = f.matr
	AND aa.cod_eve = e.cod_even
	AND aa.mes_ano = :mesAno
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
--	AND f.cod_reg IN ('1', '3', '6', '7')
GROUP BY f.matr, f.cpf, f.cod_clasf, e.v_d_even, aa.cod_eve, aa.val_tot

UNION

-- CONSULTA � TABELA DE DECIMO TERCEIRO DOS ATIVOS
select 
-- Tratamento para n�o listar CPF menor que 11 d�gitos
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF', -- N� do CPF do servidor
isnull(CAST(substring(f.cod_clasf,2,4) AS VARCHAR), '9999') 'CARGO', -- C�digo do cargo ou fun��o
substring(RTRIM(LTRIM(CAST(f.matr AS VARCHAR))),1,15) 'MATR�CULA', -- N�mero da Matr�cula
:mesAno 'MES/ANO', -- M�s e ano de refer�ncia
CASE WHEN e.V_D_EVEN = 'V' THEN 0 ELSE 1 END '0 � V | 1 - D',  -- C�digo da opera��o
'1' + CAST(aa.COD_EVE AS VARCHAR) 'COD_V_D', -- C�digo da vantagem ou desconto
'1' 'TIPO FOLHA',-- Tipo de folha (0 � Normal | 1 � 13� Sal. | 2 � F. Extra | 3 � F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- C�digo do agrupamento da Folha
-- RH_TESTE (inativos)
from funcionarios f,
	fichas_temp13 aa,
	eventos e
WHERE	aa.mat_past = f.matr
	AND aa.cod_eve = e.cod_even
	AND tipo_13sal = :tipo13Sal
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
--	AND f.cod_reg IN ('1', '3', '6', '7')
GROUP BY f.matr, f.cpf, f.cod_clasf, e.v_d_even, aa.cod_eve, aa.val_tot


UNION

-- CONSULTA � TABELA BENEFICI�RIO
select
-- Tratamento para n�o listar CPF menor que 11 d�gitos
RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))) 'CPF', -- N� do CPF do servidor
--CASE WHEN substring(fu.cod_clasf,2,4) = '2026' THEN
--	'9999' ELSE
--	ISNULL(CAST(substring(fu.cod_clasf,2,4) AS VARCHAR), '9999') END 'CARGO', -- C�digo de identifica��o do cargo
 '9999' 'CARGO', -- C�digo de identifica��o do cargo
substring(RTRIM(LTRIM(CAST(f.matr_ben AS VARCHAR))),1,15) 'MATR�CULA', -- N�mero da Matr�cula
:mesAno 'MES/ANO', -- M�s e ano de refer�ncia
CASE WHEN e.V_D_EVEN = 'V' THEN 0 ELSE 1 END '0 � V | 1 - D',  -- C�digo da opera��o
'1' + CAST(aa.COD_EVE AS VARCHAR) 'COD_V_D', -- C�digo da vantagem ou desconto
'0' 'TIPO FOLHA',-- Tipo de folha (0 � Normal | 1 � 13� Sal. | 2 � F. Extra | 3 � F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- C�digo do agrupamento da Folha
from beneficiarios f,
	ficha_beneficiario aa,
	eventos e
WHERE	aa.mat_past = f.matr_ben
	AND aa.cod_eve = e.cod_even
	AND aa.mes_ano = :mesAno
	AND tip_ben = '3'
GROUP BY f.matr_ben, f.cpf_ben, e.v_d_even, aa.cod_eve, aa.val_tot

UNION

-- CONSULTA � TABELA DE DECIMO TERCEIRO DOS BENEFICIARIOS COM O CAMPO tip_ben IGUAL A 3
select
-- Tratamento para n�o listar CPF menor que 11 d�gitos
RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))) 'CPF', -- N� do CPF do servidor
--CASE WHEN substring(fu.cod_clasf,2,4) = '2026' THEN
--	'9999' ELSE
--	ISNULL(CAST(substring(fu.cod_clasf,2,4) AS VARCHAR), '9999') END 'CARGO', -- C�digo de identifica��o do cargo
 '9999' 'CARGO', -- C�digo de identifica��o do cargo
substring(RTRIM(LTRIM(CAST(f.matr_ben AS VARCHAR))),1,15) 'MATR�CULA', -- N�mero da Matr�cula
:mesAno 'MES/ANO', -- M�s e ano de refer�ncia
CASE WHEN e.V_D_EVEN = 'V' THEN 0 ELSE 1 END '0 � V | 1 - D',  -- C�digo da opera��o
'1' + CAST(aa.COD_EVE AS VARCHAR) 'COD_V_D', -- C�digo da vantagem ou desconto
'1' 'TIPO FOLHA',-- Tipo de folha (0 � Normal | 1 � 13� Sal. | 2 � F. Extra | 3 � F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- C�digo do agrupamento da Folha
from beneficiarios f,
	ben_fichas13 aa,
	eventos e
WHERE	aa.mat_ben = f.matr_ben
	AND aa.cod_eve = e.cod_even
	AND tip_ben = '3'
	AND aa.tipo_13sal = :tipo13Sal
GROUP BY f.matr_ben, f.cpf_ben, e.v_d_even, aa.cod_eve, aa.val_tot
