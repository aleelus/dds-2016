package repositorios

import excepciones.InvalidUserException
import java.util.ArrayList
import java.util.List
import observers.ObserverBusqueda
import org.apache.commons.collections15.Predicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.hibernate.Criteria
import org.hibernate.criterion.Restrictions
import org.uqbar.commons.utils.ApplicationContext
import usuario.Rol
import usuario.Terminal

@Accessors
class RepoUsuarios extends RepoDefault<Terminal> {
	
//	override protected Predicate<Terminal> getCriterio(Terminal terminal) {
//		var resultado = this.criterioTodas
//		if (terminal.nombreTerminal != null) {
//			resultado = new AndPredicate(resultado, this.getCriterioPorNombre(terminal.nombreTerminal))
//		}
//		if (terminal.rolTerminal != null) {
//			resultado = new AndPredicate(resultado, this.getCriterioPorRol(terminal.rolTerminal))
//		}
//		resultado
//	}

//	override protected getCriterioTodas() {
//		[Terminal terminal|true] as Predicate<Terminal>
//	}


	def getCriterioPorNombre(String nombre) {
		[Terminal terminal|terminal.nombreTerminal.equals(nombre)] as Predicate<Terminal>
	}

	def getCriterioPorRol(Rol rol) {
		[Terminal terminal|terminal.rolTerminal.equals(rol)] as Predicate<Terminal>
	}


	override getEntityType() {
		typeof(Terminal)
	}
	
	override addQueryByExample(Criteria criteria, Terminal terminal) {
		if (terminal.nombreTerminal != null) {
			criteria.add(Restrictions.eq("nombreTerminal", terminal.nombreTerminal))
		}
	}

	def void agregarAccionATodos(ObserverBusqueda observer) {
		allInstances.forEach[user|user.agregarObserver(observer)]
	}

	def chequearCantObservers(int i) {
		allInstances.forall[usuario|usuario.tieneCantObservers(i)]
	}

	def quitarAccionATodos(ObserverBusqueda observer) {
		allInstances.forEach[user|user.eliminarObserver(observer)]
	}

	def clonar() throws CloneNotSupportedException{
		val repoCopia = new RepoUsuarios
		val listaTerminales = new ArrayList<Terminal>
		allInstances.forEach[terminal|listaTerminales.add(new Terminal(terminal))]
		listaTerminales.forEach[terminal|repoCopia.saveOrUpdate(terminal)]
		repoCopia
	}

	def ContieneAcciones(List<ObserverBusqueda> acciones) {
		allInstances.forall[user|user.TieneAcciones(acciones)]
	}

	def existeUsuario(String nombre) {
		allInstances.exists[user|user.nombreTerminal.equalsIgnoreCase(nombre)]
	}

	def coincidePass(String nombre, String pass) {
		allInstances.exists[user|user.nombreTerminal == nombre && user.contraseña == pass]
	}

	def getTerminal(Terminal terminal) {
		allInstances.findFirst[user|user.nombreTerminal.equalsIgnoreCase(terminal.nombreTerminal)]
	}
	
	def updateUsuario(Terminal terminal){
		
		this.update(terminal)
		
	}

	def validarLogin(Terminal terminal) {
		if (!existeUsuario(terminal.nombreTerminal)) {
			throw new InvalidUserException("El usuario no existe")
		} else if (!coincidePass(terminal.nombreTerminal, terminal.contraseña)) {
			throw new InvalidUserException("La password no coincide")
		}
		this.getTerminal(terminal)		
	}
	

}
