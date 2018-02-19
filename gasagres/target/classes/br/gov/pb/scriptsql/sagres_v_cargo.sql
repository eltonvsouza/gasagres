select distinct
CAST(cod_grp+cod_carg AS VARCHAR) 'CÓDIGO', -- Código de identificação do cargo
substring(desc_carg,1,60) 'DESCRIÇÃO', -- Nomenclatura do cargo
CASE WHEN cod_grp = '00' THEN '0' -- Inativos / Pensionistas
	WHEN cod_grp IN ('01','02','03','04','05','06','07','08','09','10','11') THEN '1' -- Efetivos
	WHEN cod_grp = '63' THEN '2' -- Eletivos
	WHEN cod_grp IN ('45','50','51','52','53', '54','55','56','57','59','64','65','68','70','71') THEN '3' -- Cargo comissionado
	WHEN cod_grp IN ('58','61','62','72','73','74','75','76','77') THEN '4' -- Função de confiança
	WHEN cod_grp = '99' THEN '5' -- Contratação por excepcional interesse público
	END 'TIPO', -- Tipo de cargo  
'0' 'Escolaridade', -- Escolaridade mínima exigida para o cargo
cod_cbo 'CBO' -- Código brasileiro de ocupação (CBO)
from cargos
WHERE	RTRIM(LTRIM(cod_grp)) IN (NULL, '')
		OR RTRIM(LTRIM(cod_carg)) IN (NULL, '')
		OR RTRIM(LTRIM(desc_carg)) IN (NULL, '')
		OR RTRIM(LTRIM(cod_cbo)) IN (NULL, '')