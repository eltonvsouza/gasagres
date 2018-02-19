package br.gov.pb.bean;

/**
 * Classe responsável por validar os dados extraídos do banco de dados de acordo com o layout de importação.
 * 
 * @author Elton Veiga de Souza
 * @version 1.0
 * @since 1.0
 */

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import br.gov.pb.consulta.ValidaDados;

@Component
@Scope("session")
public class ValidaDadosBean {

	private String data;
	@Autowired
	private ValidaDados validaDado;
	private List<Object[]> servidor;
	private List<Object[]> matricula;
	private List<Object[]> historicoFuncional;
	private List<Object[]> folhaPagamento;
	private List<Object[]> vantagemDesconto;
	private List<Object[]> cargo;
	private Date hoje = new Date();
	
	/**
	 * Construtor da classe.
     */
	public ValidaDadosBean() {
//		DateFormat formatter = new SimpleDateFormat("MMyyyy");
//		data2 = formatter.format(hoje);
	}
	
	/**
	 * Método que retorna a data, mês e ano em String, ex.: "012015" (Janeiro de 2015).
     * @return data
     */
	public String getData() {
		return data;
	}

	/**
	 * Método que seta uma data.
	 * @param data String.
	 */
	public void setData(String data) {
		this.data = data;
	}
	
	public List<Object[]> getServidor() throws Exception {
		servidor = validaDado.getServidor(data);
		return servidor;
	}
	
	public void setServidor(List<Object[]> servidor) {
		this.servidor = servidor;
	}
	
	public List<Object[]> getMatricula() throws Exception {
		matricula = validaDado.getMatricula(data);
		return matricula;
	}
	
	public void setMatricula(List<Object[]> matricula) {
		this.matricula = matricula;
	}
	
	public List<Object[]> getHistoricoFuncional() throws Exception {
		historicoFuncional = validaDado.getHistoricoFuncional(data);
		return historicoFuncional;
	}
	
	public void setHistoricoFuncional(List<Object[]> historicoFuncional) {
		this.historicoFuncional = historicoFuncional;
	}
	
	public List<Object[]> getFolhaPagamento() throws Exception {
		folhaPagamento = validaDado.getFolhaPagamento(data);
		return folhaPagamento;
	}
	
	public void setFolhaPagamento(List<Object[]> folhaPagamento) {
		this.folhaPagamento = folhaPagamento;
	}
	
	public List<Object[]> getVantagemDesconto() throws Exception {
		vantagemDesconto = validaDado.getVantagemDesconto();
		return vantagemDesconto;
	}
	
	public void setVantagemDesconto(List<Object[]> vantagemDesconto) {
		this.vantagemDesconto = vantagemDesconto;
	}
	
	public List<Object[]> getCargo() throws Exception {
		cargo = validaDado.getCargo();
		return cargo;
	}
	
	public void setCargo(List<Object[]> cargo) {
		this.cargo = cargo;
	}
	
	public Date getHoje() {
		return hoje;
	}

	public void setHoje(Date hoje) {
		this.hoje = hoje;
	}
	
	public String carregarValidaDados(){
		return "/tela/validaDados";
	}
}
