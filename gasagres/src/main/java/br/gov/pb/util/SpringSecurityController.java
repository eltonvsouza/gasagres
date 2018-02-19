package br.gov.pb.util;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class SpringSecurityController implements ApplicationListener{

	public void onApplicationEvent(ApplicationEvent applicationEvent){  
		if(applicationEvent instanceof AuthenticationSuccessEvent){
		}
	}

	public User login(){
		
//		/** 
//		* Método que verifica se já existe o usuário na sessão e a expira caso exista.  
//		*/   
//		private void validaUsuarioSessao(){  
//		    SessionRegistry sessionRegistry  = (SessionRegistry)ContextoUtil.recuperaBean(SESSION_REGISTRY);          
//		    for(Object obj : sessionRegistry.getAllPrincipals()){             
//		        if(((UserDetails)obj).getUsername().equalsIgnoreCase(this.login)){  
//		            for(SessionInformation si : sessionRegistry.getAllSessions(obj, false)){  
//		                sessionRegistry.removeSessionInformation(si.getSessionId());  
//		                return;  
//		            }                 
//		        }             
//		    }  
//		}
		
			SecurityContext context = SecurityContextHolder.getContext();
		    if (context instanceof SecurityContext){
		        Authentication authentication = context.getAuthentication();
		        if (authentication instanceof Authentication){
		        	User user = ((User)authentication.getPrincipal());
	        		return user;
		        }
		    }
		return null;
	}
}