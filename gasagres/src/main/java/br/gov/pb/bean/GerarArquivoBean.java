package br.gov.pb.bean;

/**
 * Classe bean de controle, responsável por gerenciar a comunicação entre a camada visual e modelagem.
 * Gera o arquivo e efetua seu download.
 * 
 * @author Elton Veiga de Souza
 * @version 1.0
 * @since 1.0
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import br.gov.pb.arquivo.GerarArquivo;


@Component
@Scope("session")
public class GerarArquivoBean {
//	private Date data;
//	@Temporal(TemporalType.DATE)
	private String data;
	private String tipo13Sal = "0";
	private String mensagem;
	@Autowired
	private GerarArquivo gerarArquivo;
	private Date hoje = new Date();
	private boolean btDownload = true;
	
	/**
	 * Contrutor da classe.
     */
	public GerarArquivoBean() {
		DateFormat formatter = new SimpleDateFormat("MMyyyy");
//		data2 = formatter.format(hoje);
//		data2 = "042014";
		this.data = formatter.format(this.hoje);
	}
	
	/**
	 * Método que retorna uma mensagem.
     * @return mensagem
     */
	public String getMensagem() {
		return mensagem;
	}

	/**
	 * Método que seta uma mensagem.
	 * @param mensagem Mensagem.
	 */
	public void setMensagem(String mensagem) {
		this.mensagem = mensagem;
	}
	
	public String getTipo13Sal() {
		return tipo13Sal;
	}
	
	public void setTipo13Sal(String tipo13Sal) {
		this.tipo13Sal = tipo13Sal;
	}
	
//	public GerarArquivo getGeraArquivoBean() {
//		return gerarArquivo;
//	}
//	
//	public void setGerarArquivo(GerarArquivo gerarArquivo) {
//		this.gerarArquivo = gerarArquivo;
//	}

	/**
	 * Método que retorna a data.
     * @return data
     */
	public String getData() {
		return data;
	}

	/**
	 * Método que seta a data.
	 * @param data String.
	 */
	public void setData(String data) {
		this.data = data;
	}

//	public String getData() {
//		return data;
//	}
//	
//	public void setData(String data) {
//		this.data = data;
//	}
	
	/**
	 * Método que retorna a data atual (hoje).
     * @return consultaSQL
     */
	public Date getHoje() {
		return hoje;
	}

	/**
	 * Método que seta a data atual (hoje).
	 * @param hoje Date.
	 */
	public void setHoje(Date hoje) {
		this.hoje = hoje;
	}
	
	/**
	 * Método que retorna o valor boleano do botão (true/false).
     * @return btDownload
     */
	public boolean isBtDownload() {
		return btDownload;
	}
	
	/**
	 * Método que seta o valor boleano do botão (true/false).
	 * @param btDownload - boolean.
	 */
	public void setBtDownload(boolean btDownload) {
		this.btDownload = btDownload;
	}
	
	/**
	 * Método que chama a tela principal (index). 
     */
	public String carregarIndex(){
		return "/tela/index";
	}
	
	/**
	 * Método que gera e compacta os arquivos txt's. 
     */
	public void gerarArquivos(){
	    if (Integer.parseInt(this.data.substring(0, 2)) > 31){
	      System.out.println("\n ##### Data inválida ##### ##### ");
	      FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Data inválida", "Data inválida");
	      FacesContext.getCurrentInstance().addMessage("formArquivo", message);
	    }else{
	      try{
	        this.gerarArquivo.gerarArquivo(this.data, tipo13Sal);
	        this.btDownload = false;
	        this.gerarArquivo.comprimir();
	      }catch (Exception e){
	        e.printStackTrace();
	        System.out.println("\n ##### Script SQL não encontrado: ##### ##### ");
	        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Script SQL não encontrado", "Script SQL não encontrado");
	        FacesContext.getCurrentInstance().addMessage("formArquivo", message);
	      }
	    }
	  }
	
	/**
	 * Método que efetua o download dos arquivos txt's compactados (ArquivoSagres.zip).  
     */
	public void download(){
		btDownload = false;
		FacesContext facesContext = FacesContext.getCurrentInstance();
		ExternalContext externalContext = facesContext.getExternalContext();
		  File file = new File("C:\\ArquivoSagres\\ArquivoSagres.zip");
		  if (!file.exists()) {
			  System.out.println("\n ##### Arquivo indisponível para donwload... ##### ##### ");
			  FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, "Arquivo indisponível para donwload", "Arquivo indisponível para donwload");
			  FacesContext.getCurrentInstance().addMessage("formArquivo", message);
		} else {
		  HttpServletResponse httpServletResponse = (HttpServletResponse) externalContext.getResponse();
		  httpServletResponse.setHeader("Content-Disposition", "attachment;filename="+file.getName()); 
		  httpServletResponse.setContentLength((int) file.length());
		  httpServletResponse.setContentType("zip");
		  try {
		    FileInputStream fileInputStream = new FileInputStream(file);
		    OutputStream outputStream = httpServletResponse.getOutputStream();
		    byte[] buf = new byte[(int) file.length()];
		    int count;
		    while ((count = fileInputStream.read(buf)) >= 0) {
		      outputStream.write(buf, 0, count);
		    }
		    fileInputStream.close();
		    outputStream.flush();
		    outputStream.close();
		    facesContext.responseComplete();
		  } catch (IOException ioe) {
		    System.err.println(ioe.getMessage());
		  }
		  file.delete();
		}
//		limpar();
		  btDownload = true;
	}

	/**
	 * Método que seta os valores default dos campos da tela principal (index).  
     */
	public void limpar() {
		data = null;
		data = "012014";
	}

}
