package br.gov.pb.dao.utility;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.springframework.stereotype.Service;

@Service
public class HibernateUtility {

	static private SessionFactory sessionFactory;
	static private Session session;

	static public Session getSession() {
		try {
			sessionFactory = new AnnotationConfiguration().configure(
					"/hibernate.cfg.xml").buildSessionFactory();
		} catch (Exception e) {
			sessionFactory = null;
			e.printStackTrace();
		}
		return session = sessionFactory.openSession();
	}
}

