-- APOSENTADO
SELECT
-- Campo Nº do CPF do servidor
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF',
-- Se RG for NULO ou EM BRANCO, inserir valor fixo 091091091091091
-- Campo RG do Servidor
CASE 
	WHEN f.num_ident = 'NULL' OR RTRIM(LTRIM(f.num_ident)) = '' OR f.num_ident IS NULL THEN '091091091091091'
	ELSE RTRIM(LTRIM(CAST(f.num_ident AS VARCHAR))) 
END 'RG',
-- Campo Sigla do órgão emissor
ISNULL(substring(f.org_ident,1,15), 'SSP') 'ORGAO EMISSOR',
-- Campo Nome completo do servidor
SUBSTRING(RTRIM(LTRIM(f.nome)),1,60) 'NOME',
-- Campo Data de nascimento
ISNULL(RTRIM(LTRIM(REPLACE(convert(NVARCHAR, f.dat_nasc, 103), '/', ''))),'') 'DT_NASC',
-- Campo Sexo
ISNULL(f.sexo, 'M') 'SEXO',
-- Campo Portador de deficiência física
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
-- Campo Nº do CPF do servidor
RTRIM(LTRIM(CAST(f.cpf AS VARCHAR))) 'CPF',
-- Campo RG do Servidor
CASE
	WHEN f.num_ident = 'NULL' OR RTRIM(LTRIM(f.num_ident)) = '' OR f.num_ident IS NULL THEN	'091091091091091'
	ELSE RTRIM(LTRIM(CAST(f.num_ident AS VARCHAR))) 
END 'RG',
-- Campo Sigla do órgão emissor
ISNULL(substring(f.org_ident,1,15), 'SSP') 'ORGAO EMISSOR',
-- Campo Nome completo do servidor
SUBSTRING(RTRIM(LTRIM(f.nome)),1,60) 'NOME',
-- Campo Data de nascimento
ISNULL(RTRIM(LTRIM(REPLACE(convert(NVARCHAR, f.dat_nasc, 103), '/', ''))),'') 'DT_NASC',
-- Sexo
ISNULL(f.sexo, 'M') 'SEXO',
-- Campo Portador de deficiência física
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

-- BENEFICIÁRIO
SELECT
--CASE WHEN f.cpf_ben = '44444444444' THEN '01303001446' ELSE RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))) END 'CPF', -- Nº do CPF do servidor
-- Campo Nº do CPF do beneficiario
RTRIM(LTRIM(CAST(f.cpf_ben AS VARCHAR))) 'CPF',
-- RG do beneficiario
CASE
	WHEN f.num_ident = 'NULL' OR RTRIM(LTRIM(f.num_ident)) = '' OR f.num_ident IS NULL THEN	'091091091091091'
	ELSE RTRIM(LTRIM(CAST(f.num_ident AS VARCHAR))) 
END 'RG',
-- Sigla do órgão emissor
CASE WHEN f.org_ident IS NULL OR f.org_ident = 'NULL' OR RTRIM(LTRIM(f.org_ident)) = '' THEN 'SSP'
	 ELSE substring(f.org_ident,1,15)
END 'ORGAO EMISSOR',
-- Nome completo do servidor
SUBSTRING(RTRIM(LTRIM(f.nome_ben)),1,60) 'NOME',
-- Data de nascimento
ISNULL(RTRIM(LTRIM(REPLACE(convert(NVARCHAR, f.dat_nasc, 103), '/', ''))),'') 'DT_NASC',
-- Sexo
ISNULL(f.sexo, 'M') 'SEXO',
-- Portador de deficiência física
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
--	AND f.matr <> '081116' -- servidro com mesmo cpf dos 2 beneficiários
--	AND substring(fu.cod_clasf,2,4) <> '2026'
--	AND f.cpf_ben IS NOT NULL
	--AND f.cpf_ben <> '45144222404' -- 2 banaficiários com mesmo cpf
--	AND f.cpf_ben <> '44444444444' -- cpf inválido
--	tip_ben = '3'
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
	OR f.cpf_ben COLLATE DATABASE_DEFAULT IN ('00093027435','00770758460','00874748402','01254662421','01294924427','01303001446','01362209406','01414520484','01642072796','02050548460','02253250473','02257399412','02312633418','02348298422','02421294479','02491815419','02720237442','02756947474','02908643480','02949928471','03062645440','03348306485','04964695417','05004768455','05004768455','05259462840','05630876414','05645423429','05687862463','05948713440','05953067488','06088808411','06511253406','06599763405','06783163415','06783163415','07503519428','07593655474','07635966472','09202340463','09432159434','09432159434','10435162470','11376384434','13959824491','14638894453','16020642453','16042948415','16087445404','17702089415','20356927415','20362145415','20373406487','20427794404','20565321404','20597592420','20692978453','23788402415','23807105468','25126687468','25214551487','26264170410','28203070434','28810880404','31937802434','32518293434','33815453453','37385321453','38022656453','39490157449','39492940400','39498590478','39673758468','39674525491','41438930453','42906571415','42906571415','44444444444','45081255491','45144222404','45144222404','46696610430','46698000434','48662348491','51847060463','54137292434','54169909453','56760280415','56877404491','56951655472','58504842487','60255773404','60328690406','67477780497','68985118404','70087270706','71475788487','72601612487','73917737434','75962632400','76813142453','76895335404','82643806468','83985182434','91750032449','93139845472','95225030459','95386629468','95417737453','98035886487')
GROUP BY f.matr_ben, f.tip_ben, f.cpf_ben, f.num_ident, f.org_ident, f.nome_ben, f.dat_nasc, f.sexo, f.defi_fisi, f.dat_adms
	
ORDER BY f.nome
