select
V_D_EVEN 'TIPO', -- Tipo de lançamento (0 – Vantagem | 1 - Desconto)
COD_EVEN 'CODIGO', -- Código da vantagem ou desconto
substring(DSC_EVEN, 1,40) 'DESCRICAO', -- Nomenclatura da vantagem ou desconto
CASE WHEN cod_even = 515 THEN 0 ELSE CASE WHEN V_D_EVEN = 'V' THEN 0 ELSE 1 END END 'TIPO DE CONTABILIZAÇÃO' -- Tipo de contabilização (0 – Orçamentário - vantagem | 1 – Extra-orçamentário - desconto)
from eventos
WHERE RTRIM(LTRIM(V_D_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(COD_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(DSC_EVEN)) IN (NULL, '')