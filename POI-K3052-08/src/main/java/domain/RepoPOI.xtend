package domain

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepoPOI {
	/**Lista de puntos de interés del mapa. */
	List<POI> ListaPOI = new ArrayList()

	/**Método para buscar puntos de interés dentro del mapa
	 * en base a un texto libre.
	 */
	def buscar(String input) {
		val Iterable<POI> listaResultado = ListaPOI.filter[contieneTexto(input)]
		if (listaResultado.size == 0) {
			throw new Exception("No se encontraron resultados!")
		}
		listaResultado.toList()
	}
	
	def agregarPOI(POI puntoInteres) {
		ListaPOI.add(puntoInteres)
	}
	
	def removerPOI(POI puntoInteres) {
		ListaPOI.remove(puntoInteres)
	}
	
	def modificarPOI(POI puntoInteresConNuevosDatos){
		(ListaPOI.filter[POI | POI.ID==puntoInteresConNuevosDatos.ID]).map[POIMismoID | POIMismoID.setearDatos(puntoInteresConNuevosDatos)]
	}

}
