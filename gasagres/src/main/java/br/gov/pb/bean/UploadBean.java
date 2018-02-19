package br.gov.pb.bean;

/**
 * Classe bean de controle, respons�vel por gerenciar a comunica��o entre a camada visual e modelagem.
 * Efetua o upload dos arquivos txt's.
 * 
 * @author Elton Veiga de Souza
 * @version 1.0
 * @since 1.0
 */

import br.gov.pb.arquivo.Arquivo;
import java.io.IOException;
import java.io.OutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import org.richfaces.event.FileUploadEvent;
import org.richfaces.model.UploadedFile;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope("session")
public class UploadBean implements Serializable{
	private ArrayList<UploadedFile> files = new ArrayList();
  
	/**
	 * M�todo que chama a tela upload. 
     */
	public String carregarUpload(){
		return "/tela/upload";
	}
  
	/**
	 * M�todo que escreve os dados no stream.
	 * @param stream
	 * @param object Objeto.
	 * @throws IOException 
     */
	public void paint(OutputStream stream, Object object) throws IOException{
	    stream.write(((UploadedFile)getFiles().get(((Integer)object).intValue())).getData());
	    stream.close();
	}
  
	/**
	 * M�todo que recebe os arquivos e salva na pasta "C:\ArquivoSagres\excel\".
	 * @param event Arquivo
	 * @throws Exception 
     */
	public void listener(FileUploadEvent event) throws Exception{
	    UploadedFile item = event.getUploadedFile();
	    Arquivo arquivo = new Arquivo();
	    arquivo.criaArquivoByte(item.getData(), "C:\\ArquivoSagres\\excel\\" + item.getName());
	}
  
	/**
	 * M�todo que limpa da tela os arquivos selecionados.
     * @return null
     */
	public String clearUploadData(){
	    this.files.clear();
	    return null;
	}
  
	/**
	 * M�todo que retorna o tamanho do arquivo.
     * @return int Tamanho do arquivo
     */
	public int getSize(){
		if (getFiles().size() > 0){
			return getFiles().size();
		}
		return 0;
	}
  
	/**
	 * M�todo que retorna o tempo de dura��o.
     * @return Num�rico Long
     */
	public long getTimeStamp(){
		return System.currentTimeMillis();
	}
  
	/**
	 * M�todo que retorna a lista de array com os arquivos.
     * @return Arquivos
     */
	public ArrayList<UploadedFile> getFiles(){
		return this.files;
	}
  
	/**
	 * M�todo que seta a lista de array com os arquivos.
     * @param files Arquivos
     */
	public void setFiles(ArrayList<UploadedFile> files){
		this.files = files;
	}
}
