package br.gov.pb.arquivo;

/**
 * Classe responsável por manipular arquivos.
 * Fonte: http://www.mballem.com/post/manipulando-arquivo-txt-com-java
 * 
 * @author Elton Veiga de Souza
 * @version 1.0
 * @since 1.0
 */

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class Arquivo {

	/**
	 * Método responsável por criar pasta e arquivo, com seu conteúdo.
	 * Criar arquivo com seu conteúdo.
     * @param conteudo Conteúdo do arquivo
     * @param nome Nome do arquivo
     * @param local Local do arquivo
     * @throws IOException
     */
	public void criaArquivo(String conteudo, String nome, String local) throws IOException{
	    String pasta = local;
	    
	    File diretorio = new File("C:\\ArquivoSagres");
	    File diretorio2 = new File(pasta);
	    
	    if (!verificaExistencia(diretorio)) {
	    	diretorio.mkdir();
	    }
	    
	    if (!verificaExistencia(diretorio2)) {
	    	diretorio2.mkdir();
	    }
	    
	    File arquivo = new File(diretorio2, nome);
	    
	    if (!verificaExistencia(arquivo)) {
	    	try{
	    		arquivo.createNewFile();
	    	}catch (IOException e){
	    		e.printStackTrace();
	    	}
	    }
	    
	    FileWriter fileWriter = new FileWriter(arquivo, false);
	    PrintWriter printWriter = new PrintWriter(fileWriter);
	    printWriter.println(conteudo);
	    printWriter.flush();
	    printWriter.close();
	}
	
	/**
	 * Método responsável por verificar a existencia de um objeto (pasta ou arquivo).
     * @param objeto Pasta ou arquivo que terá sua existência verificada.
     * @return true/false
     */
	public boolean verificaExistencia(File objeto){
		if (objeto.exists()){
			System.out.println("O objeto existe!");
			return true;
	    }
		
    	System.out.println("O objeto não existe!");
	    return false;
	}
  
	/**
	 * Método que tranforma um array de byte em arquivo.
     * @param conteudo Conteúdo do arquivo
     * @param local Local (pasta) em que o arquivo será salvo/criado
     * @throws IOException
     */
	public void criaArquivoByte(byte[] conteudo, String local) throws IOException{
	    File file = new File(local);
	    FileOutputStream fileOutputStream = new FileOutputStream(file);
	    fileOutputStream.write(conteudo);
	    fileOutputStream.close();
	}

		
//	verifica se é arquivo ou diretorio
	
//		File dir = new File("C:\\TutorialArquivos");
//		 
//		File dir2 = new File(dir + "\\DiretorioDois");
//		dir2.mkdirs();
//		File dir3 = new File(dir + "\\DiretorioTres");
//		dir3.mkdir();
//		 
//		File arq3 = new File(dir, "arq_03.txt");
//		try {
//		         arq3.createNewFile();
//		} catch (IOException e) {
//		         e.printStackTrace();
//		}
//		 
//		for ( File f : dir.listFiles() ) {
//		         if ( f.isDirectory() ) {
//		                 System.out.println(f + " é um diretório.");
//		         } else if (f.isFile()) {
//		                 System.out.println(f.getName() + " é um arquivo.");
//		         }
//		}
	
	
//	lista arquivos
//		File files = new File("C:\\");
//		for (File file : files.listFiles()) {
//		    System.out.println(file);
//		}
	

	
//	deleta
//		System.out.println( dir3.delete() );
//		System.out.println( arq3.delete() );
}
