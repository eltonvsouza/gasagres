package br.gov.pb.arquivo;

/**
 * Classe responsável por gerar o conteúdo e arquivos txt's a serem importados (ler/incorporar/gerar) no "Sagres Captura Pessoal".
 * 
 * @author Elton Veiga de Souza
 * @version 1.0
 * @since 1.0
 */

import br.gov.pb.aspect.Aspecto;
import br.gov.pb.consulta.ConsultaSQL;
import br.gov.pb.util.ReadXLS;
import br.gov.pb.util.ZipUtils;
import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.net.URL;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Service
public class GerarArquivo {
	@Autowired
	private ConsultaSQL consultaSQL;
	private String codigoUG = "302095";
	
	/**
	 * Método que retorna a classe ConsultaSQL.
     * @return consultaSQL
     */
	public ConsultaSQL getConsultaSQL() {
		return consultaSQL;
	}

	/**
	 * Método que seta a classe ConsultaSQL.
	 * @param consultaSQL Classe ConsultaSQL.
	 */
	public void setConsultaSQL(ConsultaSQL consultaSQL) {
		this.consultaSQL = consultaSQL;
	}
	
	/**
	 * Método que retorna o Código da Unidade Gestora.
     * @return codigoUG
     */
	public String getCodigoUG() {
		return codigoUG;
	}
	
	/**
	 * Método que seta o Código da Unidade Gestora.
	 * @param codigoUG String - Código da Unidade Gestora.
	 */
	public void setCodigoUG(String codigoUG) {
		this.codigoUG = codigoUG;
	}

	/**
	 * Método que acessa todos os métodos responsáveis por gerar o conteúdo de todos os arquivos txt's. 
     * @param data Mês e Ano de referência, Formato: 01/2014 (Janeiro de 2014)
     * @throws IOException
     * @throws InvalidFormatException
     */
	@Transactional
	public void gerarArquivo(String data, String tipo13Sal) throws IOException, InvalidFormatException{
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String dataParam = data.replace("/", "");
		
//		arquivoServidor(dataParam, caminhoScript, tipo13Sal);
//		arquivoMatricula(dataParam, caminhoScript, tipo13Sal);
//		arquivoCargo(dataParam, caminhoScript);
//		arquivoHistoricoFuncional(dataParam, caminhoScript);
//		arquivoVantagemDesconto(dataParam, caminhoScript);
		arquivoFolhaPagamento(dataParam, caminhoScript, tipo13Sal);
//		arquivoAgrupamentoFP(dataParam, caminhoScript);
	}
	
	/**
	 * Método que comprimi todos os arquivos txt's existentes na pasta "C:\\ArquivoSagres\\Arquivos" gerando a saída "C:\\ArquivoSagres\\ArquivoSagres.zip". 
     * @throws IOException
     */
	public void comprimir() throws IOException{
		File input = new File("C:\\ArquivoSagres\\Arquivos");
		File output = new File("C:\\ArquivoSagres\\ArquivoSagres.zip");
		ZipUtils.compress(input, output);
//		input.delete();
	}
	
	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "Servidores.txt" e seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoServidor(String data, String caminhoScript, String tipo13Sal) throws IOException, InvalidFormatException {
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_servidor.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, data);
		
//		ReadXLS readXLS = new ReadXLS();
//	    String createTable = "CREATE TABLE ##cpftemp(cpf char(11) not null);";
//	    this.consultaSQL.executaQuery(createTable);
//	    List<String> listaCPF = readXLS.getColunaLista(0, 1, 5, "string", "C:\\ArquivoSagres\\excel\\servidor.xlsx");
//	    for (String l : listaCPF){
//	      String consulta = "INSERT INTO ##cpftemp VALUES('" + l + "')";
////	      System.out.println(consulta);
//	      this.consultaSQL.executaQuery(consulta);
//	    }
//	    List<Object[]> lista = this.consultaSQL.executaScript(script, data);
//	    String dropTable = "DROP TABLE ##cpftemp";
//	    this.consultaSQL.executaQuery(dropTable);
		
		
		
		
//		List<Object[]> lista = readXLS("servidor.xlsx", script, data, 11, 0, 1, 5);
		
		String conteudo = "";
		for (Object[] l : lista) {
			conteudo +=
				codigoUG + 
				StringUtils.leftPad(l[0].toString(), 11, '0') + //CPF
				StringUtils.leftPad(l[1].toString(), 15, '0') + //RG
				StringUtils.rightPad(l[2].toString(), 15, ' ') + //Sigla Orgão Emisso RG
				StringUtils.rightPad(l[3].toString(), 60, ' ') + //Nome Servidor
				StringUtils.leftPad(l[4].toString(), 8, '0') + // Data nascimento
				StringUtils.leftPad(l[5].toString(), 1, ' ') + //Sexo
				l[6] + //Deficiente
				"000000" +//TCE
				 "\n";
		}
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data + "Servidores.txt", "C:\\ArquivoSagres\\Arquivos");
	}
	
	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "Matricula.txt" e seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoMatricula(String data, String caminhoScript, String tipo13Sal) throws IOException, InvalidFormatException {
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_matricula.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, data);
		
//		ReadXLS readXLS = new ReadXLS();
//	    String createTable = "CREATE TABLE ##cpftemp(cpf char(11) not null);";
//	    this.consultaSQL.executaQuery(createTable);
//	    List<String> listaCPF = readXLS.getColunaLista(0, 1, 5, "string", "C:\\ArquivoSagres\\excel\\servidor.xlsx");
//	    for (String l : listaCPF){
//	      String consulta = "INSERT INTO ##cpftemp VALUES('" + l + "')";
////	      System.out.println(consulta);
//	      this.consultaSQL.executaQuery(consulta);
//	    }
//	    List<Object[]> lista = this.consultaSQL.executaScript(script, data);
//	    String dropTable = "DROP TABLE ##cpftemp";
//	    this.consultaSQL.executaQuery(dropTable);
		
		
		
		
		
//		List<Object[]> lista = readXLS("servidor.xlsx", script, data, 11, 0, 1, 5);
		
		String conteudo = "";
		for (Object[] l : lista) {
			conteudo +=
				codigoUG + //TCE
				StringUtils.leftPad(l[0].toString(), 11, '0') + //CPF
				StringUtils.leftPad(l[1].toString(), 8, '0') + //Cargo
				StringUtils.leftPad(l[2].toString(), 15, '0') + //Matricula
				l[3] + // Data Admissão
				"000000" +//TCE
				 "\n";
		}
		
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data +  "Matricula.txt", "C:\\ArquivoSagres\\Arquivos");
	}
	
	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "Cargos.txt" e seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoCargo(String data, String caminhoScript) throws IOException, InvalidFormatException {
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_cargo.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, "");
		

//	    ReadXLS readXLS = new ReadXLS();
//	    String createTable = "CREATE TABLE ##cargotemp(codigo char(8) not null);";
//	    
//	    this.consultaSQL.executaQuery(createTable);
//	    List<String> listaCod = readXLS.getColunaLista(0, 1, 5, "string", "C:\\ArquivoSagres\\excel\\cargo.xlsx");
//	    for (String l : listaCod)	    {
//	      String consulta = "INSERT INTO ##cargotemp VALUES('" + l + "')";
////	      System.out.println(consulta);
//	      this.consultaSQL.executaQuery(consulta);
//	    }
//	    List<Object[]> lista = this.consultaSQL.executaScript(script, "");
//	    String dropTable = "DROP TABLE ##cargotemp";
//	    this.consultaSQL.executaQuery(dropTable);
		
		
		
		
//		List<Object[]> lista = readXLS("cargo.xlsx", script, data, 8, 0, 1, 5);
		
		String conteudo = "";
		for (Object[] l : lista) {
//			System.out.println(l[0].toString());
			conteudo += 
				"302095" + //TCE
//				codigoUG +
				StringUtils.leftPad(l[0].toString(), 8, '0') + //Código do cargo
				StringUtils.rightPad(l[1].toString(), 50, ' ') + //Nome do cargo
				l[2] + //Tipo do cargo
				l[3] + //Escolaridade
				StringUtils.leftPad(l[4].toString(), 6, '0') + // CBO
				"000000" +//TCE
				 "\n";
		}
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data +  "Cargos.txt", "C:\\ArquivoSagres\\Arquivos");
	}
	
	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "HistoricoFuncional.txt" e seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoHistoricoFuncional(String data, String caminhoScript) throws IOException, InvalidFormatException {
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_historicoFuncional.sql");
		List<Object[]> lista = this.consultaSQL.executaScript(script, data);
		
//		 ReadXLS readXLS = new ReadXLS();
//		    String createTable = "CREATE TABLE ##historicofuncionaltemp(codigo char(11) not null);";
//		    
//		    this.consultaSQL.executaQuery(createTable);
//		    List<String> listaCod = readXLS.getColunaLista(0, 0, 5, "cpf", "C:\\ArquivoSagres\\excel\\historicofuncional.xlsx");
//		    for (String l : listaCod)	    {
//		      String consulta = "INSERT INTO ##historicofuncionaltemp VALUES('" + l + "')";
////		      System.out.println(consulta);
//		      this.consultaSQL.executaQuery(consulta);
//		    }
//		    List<Object[]> lista = this.consultaSQL.executaScript(script, data);
//		    String dropTable = "DROP TABLE ##historicofuncionaltemp";
//		    this.consultaSQL.executaQuery(dropTable);
		
		
		
		
		
//		List<Object[]> lista = readXLS("cargo.xlsx", script, data, 11, 0, 0, 5);
		
		String conteudo = "";
		for (Object[] l : lista) {
			conteudo +=
				codigoUG + //TCE
				StringUtils.leftPad(l[0].toString(), 11, '0') + //CPF
				StringUtils.leftPad(l[1].toString(), 8, '0') + //Cargo
				l[2] + //Data movimentacao
				StringUtils.leftPad(l[3].toString(), 15, '0') + //Matricula
				l[4] + // Mes e Ano referencia
				StringUtils.leftPad(l[5].toString(), 11, '0') + //CPF segurado
				l[6] + //FALTOU ato movimentação
				l[7] + //Situacao Funcional
				l[8] + //Regime Previdenciário
				l[9] + //Regime Trabalho
				StringUtils.leftPad(l[10].toString(), 5, '0') + //Regime Previdenciário
				"000000" +//TCE
				 "\n";
		}
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data +  "HistoricoFuncional.txt", "C:\\ArquivoSagres\\Arquivos");
	}
	
	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "Codigo_VantagensDescontos.txt" e seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoVantagemDesconto(String data, String caminhoScript) throws IOException, InvalidFormatException {
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_codigo_vantagemDesconto.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, "");
		
//		ReadXLS readXLS = new ReadXLS();
//	    String createTable = "CREATE TABLE ##vandesctemp(codigo char(4) not null);";
//	    
//	    this.consultaSQL.executaQuery(createTable);
//	    List<String> listaCod = readXLS.getColunaLista(0, 3, 5, "vandesc", "C:\\ArquivoSagres\\excel\\vantagemdesconto.xlsx");
//	    for (String l : listaCod)
//	    {
//	      String consulta = "INSERT INTO ##vandesctemp VALUES('" + l + "')";
////	      System.out.println(consulta);
//	      this.consultaSQL.executaQuery(consulta);
//	    }
//	    List<Object[]> lista = this.consultaSQL.executaScript(script, "");
//	    String dropTable = "DROP TABLE ##vandesctemp";
//	    this.consultaSQL.executaQuery(dropTable);
		
		
		
		
		
//		List<Object[]> lista = readXLS("cargo.xlsx", script, data, 4, 0, 3, 5);
		
		String conteudo = "";
		for (Object[] l : lista) {
			conteudo +=
				codigoUG + //TCE
				l[0] + //Tipo Lancamento
				StringUtils.leftPad(l[1].toString(), 6, '0') + //Código
				StringUtils.rightPad(l[2].toString(), 40, ' ') + //Descricao
				l[3] + //Tipo de contabilização
				"000000" +//TCE
				 "\n";
		}
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data +  "Codigo_VantagensDescontos.txt", "C:\\ArquivoSagres\\Arquivos");
	}

	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "FolhaPagamento.txt" e seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoFolhaPagamento(String data, String caminhoScript, String tipo13Sal) throws IOException {
		String script;
		List<Object[]> lista;
		
		if(tipo13Sal.equals("0")){
			script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_folhaPagamento.sql");
			lista = consultaSQL.executaScript(script, data);
		}else{
			script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_folhaPagamento13.sql");
			lista = consultaSQL.executaScript(script, data, tipo13Sal);
		}
		
		String conteudo = "";
		for (Object[] l : lista) {
			conteudo +=
				codigoUG + //TCE
				StringUtils.leftPad(l[0].toString(), 11, '0') + //CPF
				StringUtils.leftPad(l[1].toString(), 8, '0') + //Cargo
				StringUtils.leftPad(l[2].toString(), 15, '0') + //Matricula
				l[3] + //Mes Ano
				l[4] + //Codigo da operação
				StringUtils.leftPad(l[5].toString(), 6, '0') + //Codigo Vantagem Desconto
				l[6] + //Tipo Folha
				StringUtils.leftPad(l[7].toString().replace(".", ","), 16, '0') + //Valor
				StringUtils.leftPad(l[8].toString(), 10, '0') + //Código do agrupamento da Folha
				"000000" +//TCE
				 "\n";
		}
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data +  "FolhaPagamento.txt", "C:\\ArquivoSagres\\Arquivos");
	}
	
	/**
	 * Método que acessa e executa o script SQL.
	 * Gera o arquivo "CodigoAgrupamentoFolhaPagamento.txt" com seu conteúdo, no formato exigido no layout do "Sagres Captura Pessoal". Disponível em: http://portal.tce.pb.gov.br/aplicativos/sagres/captura/.
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param caminhoScript Caminho para o script (arquivo) SQL "sagres_servidor.sql"
     * @throws IOException
     * @throws InvalidFormatException
     */
	private void arquivoAgrupamentoFP(String data, String caminhoScript) throws IOException {
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_codigoAgrupamentoFolhaPagamento.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, "");
		
		String conteudo = "";
		for (Object[] l : lista) {
			conteudo +=
				codigoUG + //TCE
				StringUtils.leftPad(l[0].toString(), 10, ' ') + //Codigo agrupamento folha
				StringUtils.rightPad(l[1].toString(), 80, ' ') + //Descricao
				"000000" +//TCE
				 "\n";
		}
		Arquivo arquivo = new Arquivo();
		arquivo.criaArquivo(conteudo, codigoUG + data +  "CodigoAgrupamentoFolhaPagamento.txt", "C:\\ArquivoSagres\\Arquivos");
	}
	
	/**
	 * Método que acessa o arquivo xls informado por parâmetro.
	 * Armazenando seu conteúdo numa tabela temporária (##tempXLS).
	 * Executa o script SQL informado por parâmetro.
	 * Deleta a tabela temporária.
	 * Retorna uma lista resultante da consulta.
	 * @param arquivoXLS Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param script Caminho para o script (arquivo) SQL "sagres_servidor.sql"
	 * @param data Mês e Ano de referência, Formato: 012014 (Janeiro de 2014)
	 * @param tamanhoCampo Tamanho do campo da tabela temporária.
	 * @param aba Aba a ser acessada no arquivo xls
	 * @param coluna Coluna a ser acessada no arquivo xls
	 * @param linha Linha onde se inicia a leitura da coluna do arquivo xls (para ser armazenado na tabela tamporária)  
     * @throws IOException
     * @throws InvalidFormatException
     * @return lista 
     */
	private List<Object[]> readXLS(String arquivoXLS, String script, String data, int tamanhoCampo, int aba, int coluna, int linha) throws InvalidFormatException, IOException{
		ReadXLS readXLS = new ReadXLS();
	    String createTable = "CREATE TABLE ##tempXLS(codigo char(" + tamanhoCampo + ") not null);";
	    this.consultaSQL.executaQuery(createTable);
	    List<String> listaCPF = readXLS.getColunaLista(aba, coluna, linha, "string", "C:\\ArquivoSagres\\excel\\" + arquivoXLS);
	    for (String l : listaCPF){
	      String consulta = "INSERT INTO ##tempXLS VALUES('" + l + "')";
	      this.consultaSQL.executaQuery(consulta);
	    }
	    List<Object[]> lista = this.consultaSQL.executaScript(script, data);
	    String dropTable = "DROP TABLE ##tempXLS";
	    this.consultaSQL.executaQuery(dropTable);
	    return lista;
	}
}
