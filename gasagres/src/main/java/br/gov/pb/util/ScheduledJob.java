package br.gov.pb.util;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;

import org.hibernate.annotations.Check;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.context.support.FileSystemXmlApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

//import br.com.model.Agenda;
//import br.com.model.Configuracao;
//import br.com.model.Geral;
//import br.com.model.Unidade;
//import br.com.model.Usuario;
//import br.com.util.Mail;

@Service
//@Component
//@Scope("session")
public class ScheduledJob {
	private Date today = new Date();
	@Qualifier("jobMail")
	private Mail mailService;

	public Mail getMailService() {
		return mailService;
	}

	public void setMailService(Mail mailService) {
		this.mailService = mailService;
	}

	
//	Campo		Obrigatório?	Valores permitidos	Caracteres especiais permitidos
//	Segundos		Sim			0-59				* / , -
//	Minutos			Sim			0-59				* / , -
//	Horas			Sim			0-23				* / , -
//	Dia do mês		Sim			1-31				* / , - ? L W
//	Mês				Sim			1-12 ou JAN-DEC		* / , -
//	Dia da semana	Sim			0-6 ou SUN-SAT		* / , - ? L #
//	Ano				Não			1970–2099			* / , -
	
//	fixedRate = 5000 Executa tarefa a cada 5 segundos
//	fixedDelay = 5000 Executa tarefa com intervalos de 5 segundos entre o término de uma tarefa e início de outra
//	@Scheduled(fixedRate=5000)
//	@Scheduled(fixedDelay=30000)

//	<f:event listener="#{scheduledJob.enviaEmail}" type="preRenderView" />
//	http://www.javasimples.com.br/spring-2/spring-framework-parte-7-agendamento-de-tarefas
	@Transactional
	@Scheduled(cron="00 37 15 * * *")
//	@Scheduled(fixedDelay=5000)
	public void enviaEmail(){
//		try {
//			Collection<Agenda> agenda = agendaDAOImpl.listarData(today);
//			if(!agenda.isEmpty()){
//				ApplicationContext context = new FileSystemXmlApplicationContext("src/main/resources/applicationContext.xml");
//				Mail mailService = (Mail) context.getBean("mail");
//				for (Agenda c : agenda) {
//					mailService = (Mail) context.getBean("mail");
//					String assunto = geralDAOImpl.carregarGrupoChave(c.getUnidade(), "assuntoemail", c.getAssunto()).getDescricao();
//					SimpleDateFormat simpleFormat = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");
//					String dataHora = simpleFormat.format(c.getDatahora());
//					mailService.sendMail(configuracaoDAOImpl.carregarGrupoTipo("sistema", "email").getValor().toString(), c.getEmail(), assunto + " - " + dataHora, "Data/Hora: " + dataHora + "\n\n" + c.getMensagem());
//					//		mailService.sendAlertMail("Exception occurred");
//				}
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
	}
	
}
