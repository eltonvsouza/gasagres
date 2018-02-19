--Servidor - CPF 44168934420 - Alterar
--302095441689344200000760201022013000000000600440022015000000000000102006201000000 
--302095441689344200000760201022013000000000600440022015000000000000202006201000000

-- APOSENTADOS
SELECT
-- Nº do CPF do servidor
CASE
	WHEN f.cpf = 'NULL' OR f.cpf IS NULL OR RTRIM(LTRIM(f.cpf)) = '' THEN '00000000000'
	ELSE RTRIM(LTRIM(CAST(f.cpf AS VARCHAR)))
END 'CPF',
-- Código de identificação do cargo
CASE
	WHEN f.cod_clasf IS NULL OR RTRIM(LTRIM(f.cod_clasf)) = '' THEN '9999' ELSE	CAST(SUBSTRING(f.cod_clasf,2,4) AS VARCHAR)
END 'CARGO',
-- Data da movimentação funcional
CASE WHEN EXISTS (
	SELECT 1
	FROM relotacoes re
	WHERE re.matr = f.matr
		and re.cod_unid_destino = f.cod_unid
	)
	THEN
	(
	SELECT TOP 1 RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, re.data_relotacoes, 103), '/', '')))                   
  	FROM relotacoes re
  	WHERE re.matr = f.matr 
  		AND re.cod_unid_destino = f.cod_unid
  	)
	ELSE
 	CASE
 		WHEN f.dt_adm IS NULL THEN '01011900'
 		ELSE RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, f.dt_adm, 103), '/', '')))
 	END
END 'MOVIMENTAÇÃO',
-- Número da matrícula do servidor
SUBSTRING(RTRIM(LTRIM(CAST(f.matr AS VARCHAR))),1,15) 'MATRÍCULA',
-- Mês e ano de referência
:mesAno 'MES/ANO',
-- Nº do CPF do segurado
'' 'CPF Seg.',
-- ato movimentação
'24' 'TIPO ATO MOVIMENTACAO PESSOAL',
-- Situação funcional
CASE
	WHEN f.sit_func = '01' THEN '0' 
	WHEN f.sit_func = '02' THEN '1'
    ELSE '99'
END 'SITUAÇÃO FUNCIONAL',
-- Tipo de regime previdenciário
CASE
	WHEN f.cod_reg IN ('6', '7') THEN '1'
	ELSE '2'
END 'REGIME PREVIDENCIARIO',
-- Tipo de regime de trabalho
CASE
	WHEN f.cod_reg IN ('6', '7') THEN '2'
	ELSE '0'
END 'REGIME TRABALHO',
-- Lotação do servidor no cargo ou função
'06201' 'LOTACAO'
FROM funcionarios f, APOST_FICHAS ff, func_apost fa
WHERE f.matr = ff.mat_apost
	AND fa.matr_apost = ff.mat_apost
	AND ff.mes_ano = :mesAno
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND f.dt_adm >= f.dat_nasc
--	AND f.cpf COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	--AND f.cpf COLLATE DATABASE_DEFAULT NOT IN 
GROUP BY f.matr, f.cpf, f.cod_clasf, f.dt_adm, f.sit_func, f.cod_reg, f.cod_unid
	
UNION

-- ATIVOS
SELECT
-- Nº do CPF do servidor
CASE
	WHEN f.cpf = 'NULL' OR f.cpf IS NULL OR RTRIM(LTRIM(f.cpf)) = '' THEN '00000000000' ELSE RTRIM(LTRIM(CAST(f.cpf AS VARCHAR)))
END 'CPF',
-- Código de identificação do cargo
CASE
	WHEN f.cod_clasf IS NULL OR RTRIM(LTRIM(f.cod_clasf)) = '' THEN '9999'
	ELSE CAST(SUBSTRING(f.cod_clasf,2,4) AS VARCHAR)
END 'CARGO',
-- Data da movimentação funcional
CASE WHEN EXISTS (
	SELECT 1
	FROM relotacoes re
	WHERE re.matr = f.matr
		AND re.cod_unid_destino = f.cod_unid
	)
	THEN
	(
	SELECT TOP 1 RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, re.data_relotacoes, 103), '/', '')))                   
	FROM relotacoes re
	WHERE re.matr = f.matr
		AND re.cod_unid_destino = f.cod_unid
	)            
	ELSE RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, f.dt_adm, 103), '/', '')))
END 'MOVIMENTAÇÃO',
-- Número da matrícula do servidor
SUBSTRING(RTRIM(LTRIM(CAST(f.matr AS VARCHAR))),1,15) 'MATRÍCULA',
-- Mês e ano de referência
:mesAno 'MES/ANO',
-- Nº do CPF do segurado
'' 'CPF Seg.',
-- ato movimentação
CASE
	WHEN f.cod_reg = '1' THEN '01' -- Efetivo
	WHEN f.cod_reg = '7' THEN '02' -- Comissionado
	WHEN f.cod_reg = '6' THEN '08' -- Emprego Público
	ELSE '99'
END 'TIPO ATO MOVIMENTACAO PESSOAL',
-- Situação funcional
CASE
	WHEN f.sit_func = '01' THEN '0' 
	WHEN f.sit_func = '02' THEN '1'
    ELSE '99'
END 'SITUAÇÃO FUNCIONAL',
-- Tipo de regime previdenciário
CASE
	WHEN f.cod_reg IN ('6', '7') THEN '1'
	ELSE '2'
END 'REGIME PREVIDENCIARIO',
-- Tipo de regime de trabalho
CASE
	WHEN f.cod_reg IN ('6', '7') THEN '2'
	ELSE '0'
END 'REGIME TRABALHO',
-- Lotação do servidor no cargo ou função
'06201' 'LOTACAO'
FROM funcionarios f, ficha_finan ff
WHERE  --NOT EXISTS(select 1 from ficha_2014 f3 where f3.mat_past = f.matr AND SUBSTRING(f3.mes_ano, 3, 4) = '2014')
	 f.matr = ff.mat_past
	AND ff.mes_ano = :mesAno
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND f.cpf COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	--AND f.cpf COLLATE DATABASE_DEFAULT NOT IN 
GROUP BY f.matr, f.cpf, f.cod_clasf, f.dt_adm, f.sit_func, f.cod_reg, f.cod_unid
	
UNION

-- BENEFICIÁRIO
SELECT
-- Nº do CPF do servidor
ISNULL(RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))),'01303001446') 'CPF',
'9999' 'CARGO',
-- Data da movimentação funcional
CASE
	WHEN f.dat_adms IS NULL
		OR RTRIM(LTRIM(CONVERT(NVARCHAR, f.dat_adms, 103))) = ''
		OR CONVERT(NVARCHAR, f.dat_adms, 103) = 'null'
		OR YEAR(f.dat_adms) < '1900'
		OR YEAR(f.dat_adms) > '2050'
		THEN '01'+:mesAno
	ELSE RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, f.dat_adms, 103), '/', '')))
END 'MOVIMENTAÇÃO',
-- Número da matrícula do servidor
substring(RTRIM(LTRIM(CAST(f.matr_ben AS VARCHAR))),1,15) 'MATRÍCULA',
-- Mês e ano de referência
:mesAno 'MES/ANO',
-- Nº do CPF do segurado
'' 'CPF Seg.',
-- ato movimentação
'25' 'TIPO ATO MOVIMENTACAO PESSOAL',
-- Situação funcional
CASE
	WHEN f.cod_sfun = '01' THEN '0' 
	WHEN f.cod_sfun = '02' THEN '1'
	ELSE '99'
END 'SITUAÇÃO FUNCIONAL',
-- Tipo de regime previdenciário
'0' 'REGIME PREVIDENCIARIO',
-- Tipo de regime de trabalho
'0' 'REGIME TRABALHO',
-- Lotação do servidor no cargo ou função
'06201' 'LOTACAO'
FROM beneficiarios f, FICHA_BENEFICIARIO aa
WHERE	aa.mat_past = f.matr_ben
	AND aa.mes_ano = :mesAno
--	AND fu.cod_reg IN ('1', '3', '6', '7')
--	AND f.num_ident IS NOT NULL
--	AND RTRIM(LTRIM(f.num_ident)) <> ''
--	AND RTRIM(LTRIM(fu.cod_clasf)) <> ''
--	AND fu.cod_clasf IS NOT NULL
--	AND YEAR(f.dat_nasc) > '1900'
--	AND substring(fu.cod_clasf,2,4) <> '2026'
--	AND f.cpf_ben IS NOT NULL
--	AND f.cpf_ben <> '10890165491'
--	AND f.cpf_ben <> '45144222404' -- 2 banaficiários com mesmo cpf
--	AND f.cpf_ben <> '44444444444' -- cpf inválido
--	AND fu.cpf <> '20693710420'
	AND tip_ben = '3'
--	AND f.cpf_ben COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	--AND f.cpf_ben COLLATE DATABASE_DEFAULT NOT IN 
GROUP BY f.matr_ben, f.cpf_ben, f.dat_adms, f.cod_sfun