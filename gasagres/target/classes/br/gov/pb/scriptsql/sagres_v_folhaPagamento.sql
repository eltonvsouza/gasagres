--CONSULTA À TABELA APOSENTADOS
select distinct
-- Tratamento para não listar CPF menor que 11 dígitos
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(f.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
f.matr 'MATRÍCULA', -- Número da Matrícula
:mesAno 'MES/ANO', -- Mês e ano de referência
e.V_D_EVEN '0 – V | 1 - D',  -- Código da operação
aa.COD_EVE 'COD_V_D', -- Código da vantagem ou desconto
'0' 'TIPO FOLHA',-- Tipo de folha (0 – Normal | 1 – 13º Sal. | 2 – F. Extra | 3 – F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- Código do agrupamento da Folha
-- RH_TESTE (inativos)
from funcionarios f,
	apost_fichas aa,
	eventos e
WHERE	aa.mat_apost = f.matr
	AND aa.cod_eve = e.cod_even
	AND aa.mes_ano = :mesAno
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr)) IN (NULL, '')
	OR RTRIM(LTRIM(e.V_D_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(aa.COD_EVE)) IN (NULL, '')
	OR RTRIM(LTRIM(aa.val_tot)) IN (NULL, ''))

UNION

-- CONSULTA À TABELA ATIVOS
select distinct
-- Tratamento para não listar CPF menor que 11 dígitos
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(f.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
f.matr 'MATRÍCULA', -- Número da Matrícula
:mesAno 'MES/ANO', -- Mês e ano de referência
e.V_D_EVEN '0 – V | 1 - D',  -- Código da operação
aa.COD_EVE 'COD_V_D', -- Código da vantagem ou desconto
'0' 'TIPO FOLHA',-- Tipo de folha (0 – Normal | 1 – 13º Sal. | 2 – F. Extra | 3 – F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- Código do agrupamento da Folha
-- RH_TESTE (inativos)
from funcionarios f,
	ficha_finan aa,
	eventos e
WHERE	aa.mat_past = f.matr
	AND aa.cod_eve = e.cod_even
	AND aa.mes_ano = :mesAno
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr)) IN (NULL, '')
	OR RTRIM(LTRIM(e.V_D_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(aa.COD_EVE)) IN (NULL, '')
	OR RTRIM(LTRIM(aa.val_tot)) IN (NULL, ''))
	
UNION

-- CONSULTA PARA DÉCIMO TERCEIRO
select distinct
-- Tratamento para não listar CPF menor que 11 dígitos
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(f.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
f.matr 'MATRÍCULA', -- Número da Matrícula
:mesAno 'MES/ANO', -- Mês e ano de referência
e.V_D_EVEN '0 – V | 1 - D',  -- Código da operação
ff.COD_EVE 'COD_V_D', -- Código da vantagem ou desconto
'1' 'TIPO FOLHA',-- Tipo de folha (0 – Normal | 1 – 13º Sal. | 2 – F. Extra | 3 – F. Suplementar)
f13.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- Código do agrupamento da Folha

-- Acessa os 2 bancos RH_PMJP (ativos, comissionados e contratados)
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
from funcionarios f,
	ficha_finan ff,
	ficha_finan13 f13,
	eventos e
where ff.mat_past = f.matr
	AND ff.mat_past = f13.mat_past
	AND ff.cod_eve = e.cod_even
	AND ff.mes_ano = :mesAno
	AND f13.mes_ano = :mesAno
	AND substring(f13.mes_ano,1,2) = '12'
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr)) IN (NULL, '')
	OR RTRIM(LTRIM(e.V_D_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(ff.COD_EVE)) IN (NULL, '')
	OR RTRIM(LTRIM(f13.val_tot)) IN (NULL, ''))

UNION

-- CONSULTA À TABELA ATIVOS
select distinct
-- Tratamento para não listar CPF menor que 11 dígitos
CAST(f.cpf_ben AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(fu.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
f.matr_ben 'MATRÍCULA', -- Número da Matrícula
:mesAno 'MES/ANO', -- Mês e ano de referência
e.V_D_EVEN '0 – V | 1 - D',  -- Código da operação
aa.COD_EVE 'COD_V_D', -- Código da vantagem ou desconto
'0' 'TIPO FOLHA',-- Tipo de folha (0 – Normal | 1 – 13º Sal. | 2 – F. Extra | 3 – F. Suplementar)
aa.val_tot 'VALOR', -- Valor da vantagem ou desconto
'6201' 'AGRUPAMENTO FOLHA'-- Código do agrupamento da Folha
-- RH_TESTE (inativos)
from beneficiarios f,
	ficha_beneficiario aa,
	eventos e,
	funcionarios fu
WHERE	aa.mat_past = f.matr_ben
	AND f.matr = fu.matr
	AND aa.cod_eve = e.cod_even
	AND aa.mes_ano = :mesAno
-- regime 1(ativo), 3(inativo), 6(contratado), 7(comissionado)
	AND (LEN(f.cpf_ben) < 11
	OR RTRIM(LTRIM(f.cpf_ben)) IN (NULL, '')
	OR RTRIM(LTRIM(fu.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr_ben)) IN (NULL, '')
	OR RTRIM(LTRIM(e.V_D_EVEN)) IN (NULL, '')
	OR RTRIM(LTRIM(aa.COD_EVE)) IN (NULL, '')
	OR RTRIM(LTRIM(aa.val_tot)) IN (NULL, ''))