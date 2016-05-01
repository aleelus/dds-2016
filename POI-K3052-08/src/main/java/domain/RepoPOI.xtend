package domain

import org.apache.commons.collections15.Predicate
import org.apache.commons.collections15.functors.AndPredicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.CollectionBasedRepo

@Accessors
class RepoPOI extends CollectionBasedRepo<POI> implements OrigenDatos {
//	/**Lista de puntos de interés del mapa. */
//	List<POI> ListaPOI = new ArrayList()
	/**Método para buscar puntos de interés dentro del mapa
	 * en base a un texto libre.
	 */
	override search(String input) {
		allInstances.filter[punto|punto.contieneTexto(input)].toList
	}

	override create(POI puntoInteres) {
		super.create(puntoInteres)
	}

	override delete(POI puntoInteres) {
		super.delete(puntoInteres)
	}

	override update(POI puntoInteres) {
		if (!allInstances.contains(puntoInteres)) {
			throw new Exception("El Punto de interés especificado no existe")
		}
		puntoInteres.validateCreate()
		super.update(puntoInteres)
	}

	override createExample() {
		new POI
	}

	override getEntityType() {
		typeof(POI)
	}

	override protected Predicate<POI> getCriterio(POI puntoInteres) {
		var resultado = this.criterioTodas
		if (puntoInteres.id != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorId(puntoInteres.id))
		}
		if (puntoInteres.nombre != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorNombre(puntoInteres.nombre))
		}
		resultado
	}

	override protected getCriterioTodas() {
		[POI punto|true] as Predicate<POI>
	}

	override protected getCriterioPorId(Integer id) {
		[POI punto|punto.id.equals(id)]
	}

	def getCriterioPorNombre(String nombre) {
		[POI punto|punto.nombre.equals(nombre)]
	}

}
