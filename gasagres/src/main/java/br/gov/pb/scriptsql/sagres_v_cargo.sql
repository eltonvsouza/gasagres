select distinct
CAST(cod_grp+cod_carg AS VARCHAR) 'C�DIGO', -- C�digo de identifica��o do cargo
substring(desc_carg,1,60) 'DESCRI��O', -- Nomenclatura do cargo
CASE WHEN cod_grp = '00' THEN '0' -- Inativos / Pensionistas
	WHEN cod_grp IN ('01','02','03','04','05','06','07','08','09','10','11') THEN '1' -- Efetivos
	WHEN cod_grp = '63' THEN '2' -- Eletivos
	WHEN cod_grp IN ('45','50','51','52','53', '54','55','56','57','59','64','65','68','70','71') THEN '3' -- Cargo comissionado
	WHEN cod_grp IN ('58','61','62','72','73','74','75','76','77') THEN '4' -- Fun��o de confian�a
	WHEN cod_grp = '99' THEN '5' -- Contrata��o por excepcional interesse p�blico
	END 'TIPO', -- Tipo de cargo  
'0' 'Escolaridade', -- Escolaridade m�nima exigida para o cargo
cod_cbo 'CBO' -- C�digo brasileiro de ocupa��o (CBO)
from cargos
WHERE	RTRIM(LTRIM(cod_grp)) IN (NULL, '')
		OR RTRIM(LTRIM(cod_carg)) IN (NULL, '')
		OR RTRIM(LTRIM(desc_carg)) IN (NULL, '')
		OR RTRIM(LTRIM(cod_cbo)) IN (NULL, '')