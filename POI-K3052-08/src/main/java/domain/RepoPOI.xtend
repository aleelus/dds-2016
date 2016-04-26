package domain

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.CollectionBasedRepo
import org.apache.commons.collections15.Predicate

@Accessors
class RepoPOI extends CollectionBasedRepo<POI> {
	/**Lista de puntos de interés del mapa. */
	List<POI> ListaPOI = new ArrayList()

	/**Método para buscar puntos de interés dentro del mapa
	 * en base a un texto libre.
	 */
	def search(String input) {
		val Iterable<POI> listaResultado = ListaPOI.filter[contieneTexto(input)]
		if (listaResultado.size == 0) {
			throw new Exception("No se encontraron resultados!")
		}
		listaResultado.toList()
	}

	override searchById(int ID) {
		super.searchById(ID)
	}

	def agregarPOI(POI puntoInteres) {
		ListaPOI.add(puntoInteres)
	}

	override create(POI puntoInteres) {
		super.create(puntoInteres)
	}

	def removerPOI(POI puntoInteres) {
		ListaPOI.remove(puntoInteres)
	}

	override delete(POI puntoInteres) {
		super.delete(puntoInteres)
	}

	def modificarPOI(POI puntoInteresConNuevosDatos) {
		(ListaPOI.filter[POI|POI.ID == puntoInteresConNuevosDatos.ID]).map [POIMismoID |
			POIMismoID.setearDatos(puntoInteresConNuevosDatos)
		]
	}

	override update(POI puntoInteres) {
		super.update(puntoInteres)
	}

	override createExample() {
		new POI
	}

	override getEntityType() {
		typeof(POI)
	}

	override protected Predicate<POI> getCriterio(POI puntoInteres) {
	}

}
