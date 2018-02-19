-- Acrescentar manualmente ao final do arquivo
-- 00000000001112APOSENTADOS                        00000000000000000411010000000 
-- 00000000009025APOSENTADOS                        00000000000000000411010000000

select distinct
CAST(cod_grp+cod_carg AS VARCHAR) 'CÓDIGO', -- Código de identificação do cargo
substring(desc_carg,1,60) 'DESCRIÇÃO', -- Nomenclatura do cargo
CASE WHEN cod_grp = '00' THEN '0' -- Inativos / Pensionistas
	WHEN cod_grp IN ('01','02','03','04','05','06','07','08','09','10','11') THEN '1' -- Efetivos
	WHEN cod_grp = '63' THEN '2' -- Eletivos
	WHEN cod_grp IN ('45','50','51','52','53', '54','55','56','57','59','64','65','68','70','71') THEN '3' -- Cargo comissionado
	WHEN cod_grp IN ('58','61','62','72','73','74','75','76','77') THEN '4' -- Função de confiança
	WHEN cod_grp = '99' THEN '5' -- Contratação por excepcional interesse público
	ELSE '6' END 'TIPO', -- Tipo de cargo  
'0' 'Escolaridade', -- Escolaridade mínima exigida para o cargo
CAST(cod_cbo AS VARCHAR) 'CBO' -- Código brasileiro de ocupação (CBO)
from cargos
--WHERE '0000' + cod_grp+cod_carg COLLATE DATABASE_DEFAULT NOT IN ('00000001','00000101','00000102','00000103','00000104','00000105','00000106','00000107','00000108','00000109','00000110','00000111','00000112','00000113','00000114','00000115','00000201','00000202','00000203','00000204','00000205','00000206','00000207','00000208','00000209','00000210','00000211','00000212','00000214','00000301','00000302','00000304','00000305','00000306','00000307','00000308','00000309','00000310','00000401','00000402','00000403','00000404','00000405','00000406','00000407','00000408','00000409','00000410','00000411','00000412','00000413','00000414','00000415','00000416','00000417','00000418','00000419','00000420','00000421','00000504','00000509','00000514','00000803','00000901','00000903','00006405','00006406','00006409','00006547','00009001','00009002','00009006','00009018','00009098','00009999')
--	AND f.cpf COLLATE DATABASE_DEFAULT NOT IN (SELECT codigo FROM ##tempXLS)

UNION ALL

SELECT '1112', 'APOSENTADOS', '0', '0', '411010'

UNION ALL

SELECT '9025', 'APOSENTADOS', '0', '0', '411010'