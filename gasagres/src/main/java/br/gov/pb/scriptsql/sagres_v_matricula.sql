select distinct
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(f.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
CAST(f.matr AS VARCHAR) 'MATRÍCULA', -- Número da Matrícula
f.dt_adm 'DT_ADMISSÃO' -- Data de nascimento
from funcionarios f, APOST_FICHAS aa
WHERE	aa.mat_apost = f.matr
	and aa.mes_ano = :mesAno
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr)) IN (NULL, '')
	OR RTRIM(LTRIM(f.dt_adm)) IN (NULL, ''))
	
UNION

select distinct
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(f.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
CAST(f.matr AS VARCHAR) 'MATRÍCULA', -- Número da Matrícula
f.dt_adm 'DT_ADMISSÃO' -- Data de nascimento
from funcionarios f, FICHA_FINAN aa
WHERE	aa.mat_past = f.matr
	and aa.mes_ano = :mesAno
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr)) IN (NULL, '')
	OR RTRIM(LTRIM(f.dt_adm)) IN (NULL, ''))

UNION

select distinct
CAST(f.cpf_ben AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(substring(fu.cod_clasf,2,4) AS VARCHAR) 'CARGO', -- Código de identificação do cargo
CAST(f.matr_ben AS VARCHAR) 'MATRÍCULA', -- Número da Matrícula
f.dat_adms 'DT_ADMISSÃO' -- Data de nascimento
from beneficiarios f, FICHA_BENEFICIARIO aa, funcionarios fu
WHERE	aa.mat_past = f.matr_ben
	AND f.matr = fu.matr
	AND aa.mes_ano = :mesAno
	AND (LEN(f.cpf_ben) < 11
	OR RTRIM(LTRIM(f.cpf_ben)) IN (NULL, '')
	OR RTRIM(LTRIM(fu.cod_clasf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.matr_ben)) IN (NULL, '')
	OR RTRIM(LTRIM(f.dat_adms)) IN (NULL, ''))