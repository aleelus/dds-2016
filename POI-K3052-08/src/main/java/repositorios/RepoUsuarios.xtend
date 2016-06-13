package repositorios

import org.uqbar.commons.model.CollectionBasedRepo
import interfazUsuario.Terminal
import org.apache.commons.collections15.functors.AndPredicate
import org.apache.commons.collections15.Predicate
import observers.ObserverBusqueda

class RepoUsuarios extends CollectionBasedRepo<Terminal> implements Cloneable {

	override protected Predicate<Terminal> getCriterio(Terminal terminal) {
		var resultado = this.criterioTodas
		if (terminal.nombreTerminal != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorNombre(terminal.nombreTerminal))
		}
		resultado
	}

	def getCriterioPorNombre(Object nombre) {
		[Terminal terminal|terminal.nombreTerminal.equals(nombre)]
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

	def agregarAccionATodos(ObserverBusqueda observer) {
		allInstances.forEach[user|user.agregarObserver(observer)]
	}
	
	override clone() throws CloneNotSupportedException {
		super.clone()
	}
	

}