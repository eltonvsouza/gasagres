select
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(f.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
case when exists (
	select 1 from relotacoes re where re.matr = f.matr                     
                   					and re.cod_unid_destino = f.cod_unid) then
   		(select top 1 re.data_relotacoes                   
        	from relotacoes re where re.matr = f.matr                     
                     				and re.cod_unid_destino = f.cod_unid)            
     		else f.dt_adm end 'MOVIMENTAÇÃO', -- Data da movimentação funcional
CAST(f.matr AS VARCHAR) 'MATRÍCULA', -- Número da matrícula do servidor
:mesAno 'MES/ANO', -- Mês e ano de referência
CAST(f.cpf AS VARCHAR) 'CPF',-- Nº do CPF do segurado
'0', -- ato movimentação
case when f.sit_func = '01' then '0' 
	 when f.sit_func = '02' then '1'
     else '99' end 'SITUAÇÃO FUNCIONAL', -- Situação funcional
CASE WHEN f.cod_reg IN ('6', '7') THEN '1'
	ELSE '2' END 'REGIME PREVIDENCIARIO',-- Tipo de regime previdenciário 
CASE WHEN f.cod_reg IN ('6', '7') THEN '2'
	ELSE '0' END 'REGIME TRABALHO', -- Tipo de regime de trabalho
'06201' 'LOTACAO'-- Lotação do servidor no cargo ou função

from FICHA_CADASTRAL f
WHERE f.mes_ano = :mesAno
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr)) IN (NULL, ''))