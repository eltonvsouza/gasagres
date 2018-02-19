package br.gov.pb.consulta;

/**
 * Respons�vel pela conex�o com o banco de dados
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
	 * M�todo que retorna a F�brica de Sess�es.
	 * @return sessionFactory
	 */
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	/**
	 * M�todo que seta a F�brica de Sess�es.
	 * @param sessionFactory Classe SessionFactory.
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	/**
	 * M�todo que carrega o script SQL a partir de um arquivo e o retorna.
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
	 * M�todo que executa um script SQL passando o m�s e ano como par�metro.
	 * @param consulta Conte�do do script SQL
	 * @param mesAno Par�mentro que ser� utilizado no script SQL 
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
	 * M�todo que executa um script SQL enviado por par�metro.
	 * @param consulta Conte�do do script SQL
     */
	public void executaQuery(String consulta){
		Query query = this.sessionFactory.getCurrentSession().createSQLQuery(consulta);
		query.executeUpdate();
	}
}
