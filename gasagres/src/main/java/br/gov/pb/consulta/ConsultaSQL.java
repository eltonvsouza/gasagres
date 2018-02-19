package br.gov.pb.consulta;

/**
 * Responsável pela conexão com o banco de dados
 * 
 * @author Elton Veiga de Souza
 * @version 1.0
 * @since 1.0
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class ConsultaSQL {
	
	@Autowired
	private SessionFactory sessionFactory;
	
	/**
	 * Método que retorna a Fábrica de Sessões.
	 * @return sessionFactory
	 */
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	/**
	 * Método que seta a Fábrica de Sessões.
	 * @param sessionFactory Classe SessionFactory.
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	/**
	 * Método que carrega o script SQL a partir de um arquivo e o retorna.
	 * @param caminho Local do arquivo
     * @throws IOException
     * @return consulta 
     */
	public String carregaScriptSQL(String caminho) throws IOException{
		String consulta = "";
		BufferedReader bufferedReader = new BufferedReader(new FileReader(caminho.substring(6).replace("/", "\\")));
		while (bufferedReader.ready()) {
		  consulta = consulta + bufferedReader.readLine() + "\n";
		}
		bufferedReader.close();
		return consulta;
	}
  
	/**
	 * Método que executa um script SQL passando o mês e ano como parâmetro.
	 * @param consulta Conteúdo do script SQL
	 * @param mesAno Parâmentro que será utilizado no script SQL 
     * @return lista
     */
	@Transactional
	public List<Object[]> executaScript(String consulta, String mesAno){
		Query query = this.sessionFactory.getCurrentSession().createSQLQuery(consulta);
		if (!mesAno.isEmpty()) {
			query.setString("mesAno", mesAno);
		}
		return query.list();
	}
	
	@Transactional
	public List<Object[]> executaScript(String consulta, String mesAno, String tipo13Sal){
		Query query = this.sessionFactory.getCurrentSession().createSQLQuery(consulta);
		if (!mesAno.isEmpty()) {
			query.setString("mesAno", mesAno);
		}
		if (!tipo13Sal.isEmpty()) {
			query.setString("tipo13Sal", tipo13Sal);
		}
		return query.list();
	}
  
	/**
	 * Método que executa um script SQL enviado por parâmetro.
	 * @param consulta Conteúdo do script SQL
     */
	public void executaQuery(String consulta){
		Query query = this.sessionFactory.getCurrentSession().createSQLQuery(consulta);
		query.executeUpdate();
	}
}
