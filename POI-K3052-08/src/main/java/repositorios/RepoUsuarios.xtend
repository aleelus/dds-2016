package repositorios

import interfazUsuario.Terminal
import observers.ObserverBusqueda
import org.apache.commons.collections15.Predicate
import org.apache.commons.collections15.functors.AndPredicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.CollectionBasedRepo
import java.util.ArrayList
import interfazUsuario.Rol

@Accessors
class RepoUsuarios extends CollectionBasedRepo<Terminal> {

	override protected Predicate<Terminal> getCriterio(Terminal terminal) {
		var resultado = this.criterioTodas
		if (terminal.nombreTerminal != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorNombre(terminal.nombreTerminal))
		}
		if (terminal.rolTerminal != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorRol(terminal.rolTerminal))
		}
		resultado
	}

	def getCriterioPorNombre(String nombre) {
		[Terminal terminal|terminal.nombreTerminal.equals(nombre)] as Predicate<Terminal>
	}

	def getCriterioPorRol(Rol rol) {
		[Terminal terminal|terminal.rolTerminal.equals(rol)] as Predicate<Terminal>
	}

	override protected getCriterioTodas() {
		[Terminal terminal|true] as Predicate<Terminal>
	}

	override createExample() {
		new Terminal
	}

	override getEntityType() {
		typeof(Terminal)
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
		listaTerminales.forEach[terminal|repoCopia.create(terminal)]
		repoCopia
	}

}
