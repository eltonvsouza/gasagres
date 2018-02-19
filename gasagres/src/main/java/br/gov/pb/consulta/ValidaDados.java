package br.gov.pb.consulta;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ValidaDados {
	
	@Autowired
	private ConsultaSQL consultaSQL;
	
	public ConsultaSQL getConsultaSQL() {
		return consultaSQL;
	}

	public void setConsultaSQL(ConsultaSQL consultaSQL) {
		this.consultaSQL = consultaSQL;
	}
	
	@Transactional
	public List<Object[]> getServidor(String data) throws Exception {
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_v_servidor.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, data.replace("/", ""));
		return lista;
	}
	
	@Transactional
	public List<Object[]> getMatricula(String data) throws Exception {
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_v_matricula.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, data.replace("/", ""));
		return lista;
	}
	
	@Transactional
	public List<Object[]> getHistoricoFuncional(String data) throws Exception {
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_v_historicoFuncional.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, data.replace("/", ""));
		return lista;
	}
	
	@Transactional
	public List<Object[]> getFolhaPagamento(String data) throws Exception {
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_v_folhaPagamento.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, data.replace("/", ""));
		return lista;
	}
	
	@Transactional
	public List<Object[]> getVantagemDesconto() throws Exception {
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_v_codigo_vantagemDesconto.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, "");
		return lista;
	}
	
	@Transactional
	public List<Object[]> getCargo() throws Exception {
		String caminhoScript = getClass().getResource("/br/gov/pb/scriptsql/").toString();
		String script = consultaSQL.carregaScriptSQL(caminhoScript + "sagres_v_cargo.sql");
		List<Object[]> lista = consultaSQL.executaScript(script, "");
		return lista;
	}
}
