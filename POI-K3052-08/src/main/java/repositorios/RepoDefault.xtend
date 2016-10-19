package repositorios

import java.util.List
import org.hibernate.HibernateException
import org.hibernate.SessionFactory
import org.hibernate.cfg.Configuration
import puntosDeInteres.CGP
import puntosDeInteres.LocalComercial
import puntosDeInteres.POI
import puntosDeInteres.ParadaColectivo
import puntosDeInteres.SucursalBanco
import usuario.Terminal
import org.hibernate.Criteria
import org.hibernate.Session
import puntosDeInteres.ServicioCGP
import puntosDeInteres.Comuna
import puntosDeInteres.Comentario
import puntosDeInteres.Rubro

abstract class RepoDefault<T> {
	
	
	private static final SessionFactory sessionFactory = new Configuration().configure()
    .addAnnotatedClass(POI)
    .addAnnotatedClass(CGP)
    .addAnnotatedClass(LocalComercial)
    .addAnnotatedClass(ParadaColectivo)
    .addAnnotatedClass(SucursalBanco)
    .addAnnotatedClass(Terminal)
    .addAnnotatedClass(ServicioCGP)
    .addAnnotatedClass(Comuna)
    .addAnnotatedClass(Comentario)
    .addAnnotatedClass(Rubro)
    .buildSessionFactory()
    
    def openSession() {
        sessionFactory.openSession
    }
        
     def List<T> allInstances() {
		val session = sessionFactory.openSession
		try {
			return session.createCriteria(getEntityType).list()
		} finally {
			session.close
		}
	}
	
	 def List<T> searchByExample(T t) {
        val session = sessionFactory.openSession
        try {
            val criteria = session.createCriteria(getEntityType)
            this.addQueryByExample(criteria, t)
            return criteria.list()
        } catch (HibernateException e) {
            throw new RuntimeException(e)
        } finally {
            session.close
        }
    }	

	
	def void saveOrUpdate(T t) {
		val session = sessionFactory.openSession();
		try {
			session.beginTransaction();
			session.saveOrUpdate(t);
			session.getTransaction().commit();
		} catch (HibernateException e) {
			session.getTransaction().rollback();
			throw new RuntimeException(e);
		} finally {
			session.close();
		}
	}
	
	def void update(T t) {
		this.saveOrUpdate(t);
	}

	def void add(T t) {
		this.saveOrUpdate(t);
	}
	
	
	def void delete(T t) {
		val session = sessionFactory.openSession();
		try {
			session.beginTransaction();
			session.delete(t);
			session.getTransaction().commit();
		} catch (HibernateException ex) {
			session.getTransaction().rollback();
			throw new RuntimeException(ex);
		} finally {
			session.close();
		}
	}
	
	

	

	def abstract Class<T> getEntityType()	
	
	def abstract void addQueryByExample(Criteria criteria, T t)

	
	
}