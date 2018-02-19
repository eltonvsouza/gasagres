select distinct
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(f.num_ident AS VARCHAR) 'RG', -- RG do Servidor
f.org_ident 'ORGAO EMISSOR', -- Sigla do órgão emissor
f.nome 'NOME', -- Nome completo do servidor
f.dat_nasc 'DT_NASC', -- Data de nascimento
f.sexo 'SEXO', -- Sexo
CAST(f.defi_fisi AS VARCHAR) 'DEFICIENTE' -- Portador de deficiência física
from funcionarios f, APOST_FICHAS aa
WHERE	aa.mat_apost = f.matr
	AND aa.mes_ano = :mesAno
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.num_ident)) IN (NULL, '')
	OR RTRIM(LTRIM(f.org_ident)) IN (NULL, '')
	OR RTRIM(LTRIM(f.nome)) IN (NULL, '')
	OR RTRIM(LTRIM(f.dat_nasc)) IN (NULL, '')
	OR RTRIM(LTRIM(f.sexo)) IN (NULL, '')
	OR RTRIM(LTRIM(f.defi_fisi)) IN (NULL, ''))

UNION

select distinct
CAST(f.cpf AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(f.num_ident AS VARCHAR) 'RG', -- RG do Servidor
f.org_ident 'ORGAO EMISSOR', -- Sigla do órgão emissor
f.nome 'NOME', -- Nome completo do servidor
f.dat_nasc 'DT_NASC', -- Data de nascimento
f.sexo 'SEXO', -- Sexo
CAST(f.defi_fisi AS VARCHAR) 'DEFICIENTE' -- Portador de deficiência física

from funcionarios f, FICHA_FINAN aa
WHERE	aa.mat_past = f.matr
	and aa.mes_ano = :mesAno
	AND (LEN(f.cpf) < 11
	OR RTRIM(LTRIM(f.cpf)) IN (NULL, '')
	OR RTRIM(LTRIM(f.num_ident)) IN (NULL, '')
	OR RTRIM(LTRIM(f.org_ident)) IN (NULL, '')
	OR RTRIM(LTRIM(f.nome)) IN (NULL, '')
	OR RTRIM(LTRIM(f.dat_nasc)) IN (NULL, '')
	OR RTRIM(LTRIM(f.sexo)) IN (NULL, '')
	OR RTRIM(LTRIM(f.defi_fisi)) IN (NULL, ''))

UNION

select distinct
CAST(f.cpf_ben AS VARCHAR) 'CPF', -- Nº do CPF do servidor
CAST(f.num_ident AS VARCHAR) 'RG', -- RG do Servidor
f.org_ident 'ORGAO EMISSOR', -- Sigla do órgão emissor
f.nome_ben 'NOME', -- Nome completo do servidor
f.dat_nasc 'DT_NASC', -- Data de nascimento
f.sexo 'SEXO', -- Sexo
CAST(f.defi_fisi AS VARCHAR) 'DEFICIENTE' -- Portador de deficiência física
from beneficiarios f, FICHA_BENEFICIARIO aa, funcionarios fu
WHERE	aa.mat_past = f.matr_ben
	AND f.matr = fu.matr
	AND aa.mes_ano = :mesAno
	AND (LEN(f.cpf_ben) < 11
	OR RTRIM(LTRIM(f.cpf_ben)) IN (NULL, '')
	OR RTRIM(LTRIM(f.num_ident)) IN (NULL, '')
	OR RTRIM(LTRIM(f.org_ident)) IN (NULL, '')
	OR RTRIM(LTRIM(f.nome_ben)) IN (NULL, '')
	OR RTRIM(LTRIM(f.dat_nasc)) IN (NULL, '')
	OR RTRIM(LTRIM(f.sexo)) IN (NULL, '')
	OR RTRIM(LTRIM(f.defi_fisi)) IN (NULL, ''))
