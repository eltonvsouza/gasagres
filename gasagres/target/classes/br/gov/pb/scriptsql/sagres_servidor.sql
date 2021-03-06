-- APOSENTADO
SELECT
-- Campo N� do CPF do servidor
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF',
-- Se RG for NULO ou EM BRANCO, inserir valor fixo 091091091091091
-- Campo RG do Servidor
CASE 
	WHEN f.num_ident = 'NULL' OR RTRIM(LTRIM(f.num_ident)) = '' OR f.num_ident IS NULL THEN '091091091091091'
	ELSE RTRIM(LTRIM(CAST(f.num_ident AS VARCHAR))) 
END 'RG',
-- Campo Sigla do �rg�o emissor
ISNULL(substring(f.org_ident,1,15), 'SSP') 'ORGAO EMISSOR',
-- Campo Nome completo do servidor
SUBSTRING(RTRIM(LTRIM(f.nome)),1,60) 'NOME',
-- Campo Data de nascimento
ISNULL(RTRIM(LTRIM(REPLACE(convert(NVARCHAR, f.dat_nasc, 103), '/', ''))),'') 'DT_NASC',
-- Campo Sexo
ISNULL(f.sexo, 'M') 'SEXO',
-- Campo Portador de defici�ncia f�sica
CAST(
	CASE
		WHEN f.defi_fisi in ('N', NULL, ' ') THEN 'N' ELSE 'S'
	END
AS VARCHAR) 'DEFICIENTE'
FROM funcionarios f,func_apost fa
WHERE  fa.matr_apost = f.matr
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND f.dt_adm >= f.dat_nasc
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
GROUP BY f.matr, f.cpf, f.num_ident, f.org_ident, f.nome, f.dat_nasc, f.sexo, f.defi_fisi, f.dt_adm

UNION

-- ATIVO
SELECT
-- Campo N� do CPF do servidor
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF',
-- Campo RG do Servidor
CASE
	WHEN f.num_ident = 'NULL' OR RTRIM(LTRIM(f.num_ident)) = '' OR f.num_ident IS NULL THEN	'091091091091091'
	ELSE RTRIM(LTRIM(CAST(f.num_ident AS VARCHAR))) 
END 'RG',
-- Campo Sigla do �rg�o emissor
ISNULL(substring(f.org_ident,1,15), 'SSP') 'ORGAO EMISSOR',
-- Campo Nome completo do servidor
SUBSTRING(RTRIM(LTRIM(f.nome)),1,60) 'NOME',
-- Campo Data de nascimento
ISNULL(RTRIM(LTRIM(REPLACE(convert(NVARCHAR, f.dat_nasc, 103), '/', ''))),'') 'DT_NASC',
-- Sexo
ISNULL(f.sexo, 'M') 'SEXO',
-- Campo Portador de defici�ncia f�sica
CAST(
	CASE
		WHEN f.defi_fisi in ('N', NULL, ' ') THEN 'N' ELSE 'S'
	END
AS VARCHAR) 'DEFICIENTE'
FROM funcionarios f
WHERE	
--	AND f.cod_reg IN ('1', '3', '6', '7')
--	AND f.cpf COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
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
GROUP BY f.matr, f.cpf, f.num_ident, f.org_ident, f.nome, f.dat_nasc, f.sexo, f.defi_fisi, f.dt_adm

UNION

-- BENEFICI�RIO
SELECT
--CASE WHEN f.cpf_ben = '44444444444' THEN '01303001446' ELSE RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))) END 'CPF', -- N� do CPF do servidor
-- Campo N� do CPF do beneficiario
RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))) 'CPF',
-- RG do beneficiario
CASE
	WHEN f.num_ident = 'NULL' OR RTRIM(LTRIM(f.num_ident)) = '' OR f.num_ident IS NULL THEN	'091091091091091'
	ELSE RTRIM(LTRIM(CAST(f.num_ident AS VARCHAR))) 
END 'RG',
-- Sigla do �rg�o emissor
CASE WHEN f.org_ident IS NULL OR f.org_ident = 'NULL' OR RTRIM(LTRIM(f.org_ident)) = '' THEN 'SSP'
	 ELSE substring(f.org_ident,1,15)
END 'ORGAO EMISSOR',
-- Nome completo do servidor
SUBSTRING(RTRIM(LTRIM(f.nome_ben)),1,60) 'NOME',
-- Data de nascimento
ISNULL(RTRIM(LTRIM(REPLACE(convert(NVARCHAR, f.dat_nasc, 103), '/', ''))),'') 'DT_NASC',
-- Sexo
ISNULL(f.sexo, 'M') 'SEXO',
-- Portador de defici�ncia f�sica
CAST(
	CASE
		WHEN f.defi_fisi in ('N', NULL, ' ') THEN 'N' ELSE 'S'
	END
AS VARCHAR) 'DEFICIENTE' 
FROM beneficiarios f
WHERE	
--	AND fu.cod_reg IN ('1', '3', '6', '7')
--	AND RTRIM(LTRIM(f.num_ident)) <> ''
--	AND YEAR(f.dat_nasc) > '1900'
--	AND YEAR(f.dat_adms) < '2015'
--	AND f.matr <> '081116' -- servidro com mesmo cpf dos 2 benefici�rios
--	AND substring(fu.cod_clasf,2,4) <> '2026'
--	AND f.cpf_ben IS NOT NULL
	--AND f.cpf_ben <> '45144222404' -- 2 banafici�rios com mesmo cpf
--	AND f.cpf_ben <> '44444444444' -- cpf inv�lido
	tip_ben = '3'
--	AND f.cpf_ben COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)
	AND EXISTS (
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
GROUP BY f.matr_ben, f.tip_ben, f.cpf_ben, f.num_ident, f.org_ident, f.nome_ben, f.dat_nasc, f.sexo, f.defi_fisi, f.dat_adms
	
ORDER BY f.nome
