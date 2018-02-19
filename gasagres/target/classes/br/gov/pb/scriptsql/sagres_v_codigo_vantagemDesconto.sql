select
V_D_EVEN 'TIPO', -- Tipo de lan�amento (0 � Vantagem | 1 - Desconto)
COD_EVEN 'CODIGO', -- C�digo da vantagem ou desconto
substring(DSC_EVEN, 1,40) 'DESCRICAO', -- Nomenclatura da vantagem ou desconto
CASE WHEN cod_even = 515 THEN 0 ELSE CASE WHEN V_D_EVEN = 'V' THEN 0 ELSE 1 END END 'TIPO DE CONTABILIZA��O' -- Tipo de contabiliza��o (0 � Or�ament�rio - vantagem | 1 � Extra-or�ament�rio - desconto)
from eventos
WHERE RTRIM(LTRIM(V_D_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(COD_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(DSC_EVEN)) IN (NULL, '')