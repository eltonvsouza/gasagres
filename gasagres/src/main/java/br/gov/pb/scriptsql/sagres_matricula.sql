--APOSENTADO
SELECT
-- Nº do CPF do servidor
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF',
-- Código de identificação do cargo
CASE
	WHEN RTRIM(LTRIM(f.cod_clasf)) = '' THEN '9999'
	ELSE ISNULL(CAST(SUBSTRING(f.cod_clasf,2,4) AS VARCHAR), '9999')
END 'CARGO',
-- Número da Matrícula
CAST(SUBSTRING(RTRIM(LTRIM(f.matr)),1,15) AS VARCHAR) 'MATRÍCULA',
-- Data de admissão
CASE
	WHEN f.dt_adm < f.dat_nasc THEN	REPLACE(CONVERT(NVARCHAR, f.dat_nasc, 103), '/', '')
	ELSE ISNULL(RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, f.dt_adm, 103), '/', ''))), REPLACE(CONVERT(NVARCHAR, f.dat_nasc, 103), '/', ''))
END 'DT_ADMISSÃO'
FROM funcionarios f, func_apost fa
WHERE f.matr = fa.matr_apost
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND f.dt_adm >= f.dat_nasc
--	AND f.cpf COLLATE DATABASE_DEFAULT IN 
--	AND f.cpf COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	AND EXISTS 	(
			SELECT 1
			FROM APOST_FICHAS ff
			WHERE f.matr = ff.mat_apost 
				AND ff.mes_ano = :mesAno)
	AND NOT EXISTS	(
				SELECT 1 
				FROM APOST_FICHAS ff 
				WHERE f.matr = ff.mat_apost 
					AND ff.mes_ano = STUFF(:mesAno, 1, 2, RIGHT('00'+ CONVERT(VARCHAR,substring(:mesAno, 1, 2)-1),2))
			  	)
GROUP BY f.matr, f.cpf, f.cod_clasf, f.dat_nasc, f.dt_adm
	
UNION

-- ATIVO
SELECT
-- Nº do CPF do servidor
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF',
-- Código de identificação do cargo
CAST(SUBSTRING(f.cod_clasf,2,4) AS VARCHAR) 'CARGO',
-- Número da Matrícula
CAST(SUBSTRING(RTRIM(LTRIM(f.matr)),1,15) AS VARCHAR) 'MATRÍCULA',
-- Data de admissão
CASE
	WHEN f.dt_adm < f.dat_nasc THEN	REPLACE(CONVERT(NVARCHAR, f.dt_adm, 103), '/', '')
	ELSE ISNULL(RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, f.dt_adm, 103), '/', ''))), REPLACE(CONVERT(NVARCHAR, f.dat_nasc, 103), '/', ''))
END 'DT_ADMISSÃO'
FROM funcionarios f
WHERE
--	AND f.cpf COLLATE DATABASE_DEFAULT IN 
--	AND f.cpf COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	--AND NOT EXISTS(select 1 from ficha_2014 f3 where f3.mat_past = f.matr AND SUBSTRING(f3.mes_ano, 3, 4) = '2014')
	EXISTS (
		SELECT 1
		FROM ficha_finan ff
		WHERE f.matr = ff.mat_past
			AND ff.mes_ano = :mesAno
	)
	AND NOT EXISTS (
		SELECT 1
		FROM ficha_finan ff
		WHERE f.matr = ff.mat_past
			AND ff.mes_ano = STUFF(:mesAno, 1, 2, RIGHT('00'+ CONVERT(VARCHAR,substring(:mesAno, 1, 2)-1),2))
	)
GROUP BY f.matr, f.cpf, f.cod_clasf, f.dat_nasc, f.dt_adm

UNION

--BENEFICIARIO
--ALGUNS ERROS NA LEITURA DO SAGRES OCORREM POR CONTA DO VALOR NULL NO CAMPO RG
SELECT 
-- Nº do CPF do servidor
ISNULL(RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))),'') 'CPF',
-- Caso a classificação funcional seja NULL, insira o cargo 9999 (SEM CARGO)
--CASE WHEN SUBSTRING(fu.cod_clasf,2,4) = '2026' THEN
--	'9999' ELSE
--	ISNULL(CAST(SUBSTRING(fu.cod_clasf,2,4) AS VARCHAR), '9999') END 'CARGO', -- Código de identificação do cargo
-- Código de identificação do cargo
'9999' 'CARGO',
-- Número da Matrícula
CAST(SUBSTRING(RTRIM(LTRIM(f.matr_ben)),1,15) AS VARCHAR) 'MATRÍCULA',
-- Data de admissão
CASE
	WHEN YEAR(f.dat_adms) < '2016' AND YEAR(f.dat_adms) >= '1900' THEN RTRIM(LTRIM(REPLACE(CONVERT(NVARCHAR, f.dat_adms, 103), '/', '')))
	ELSE '01'+:mesAno
END 'DT_ADMISSÃO'
FROM beneficiarios f
WHERE
--	AND fu.cod_reg IN ('1', '3', '6', '7')
--	tip_ben = '3'
--	AND f.cpf_ben COLLATE DATABASE_DEFAULT IN 
--	AND f.cpf_ben COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	 EXISTS (
		SELECT 1
		FROM ficha_beneficiario ff
		WHERE f.matr_ben = ff.mat_past
			AND ff.mes_ano = :mesAno
	)
	AND NOT EXISTS (
		SELECT 1
		FROM ficha_beneficiario ff 
		WHERE f.matr_ben = ff.mat_past 
			AND ff.mes_ano = STUFF(:mesAno, 1, 2, RIGHT('00'+ CONVERT(VARCHAR,substring(:mesAno, 1, 2)-1),2))
	)
GROUP BY f.matr_ben, f.tip_ben, f.cpf_ben, f.dat_adms