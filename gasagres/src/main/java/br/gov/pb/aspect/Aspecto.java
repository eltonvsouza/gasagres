package br.gov.pb.aspect;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Aspect
@Component
@Scope("session")
public class Aspecto {
	
//	@Before("execution(* *.gerarArquivos(..))")
//	public void antesGerarArquivo(){
//		System.out.println("\n ##### AGUARDE... ##### ");
//		FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO,	"AGUARDE...", "AGUARDE...");
//		FacesContext.getCurrentInstance().addMessage("formArquivo", message);
//	}

	@After("execution(* *.comprimir	(..))")
	public void depoisGerarArquivo(){
		System.out.println("\n ##### COMPRESSÃO FINALIZADA... #####");
		FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO,	"COMPRESSÃO FINALIZADA", "COMPRESSÃO FINALIZADA");
		FacesContext.getCurrentInstance().addMessage("formArquivo", message);
	}
	
	@After("execution(* *.download(..))")
	public void depoisDownload(){
		System.out.println("\n ##### INICIANDO DOWNLOAD... #####");
		FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO,	"INICIANDO DOWNLOAD", "INICIANDO DOWNLOAD");
		FacesContext.getCurrentInstance().addMessage("formArquivo", message);
	}
}