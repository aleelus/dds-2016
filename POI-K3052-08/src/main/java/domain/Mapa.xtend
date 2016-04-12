package domain

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mapa {
	List<POI> ListaPOI = new ArrayList()

	def buscar(String input) {
		val Iterable<POI> listaResultado = ListaPOI.filter[obtenerDatos().contains(input)]
		if (listaResultado.size == 0) {
			throw new Exception("No se encontraron resultados!")
		}
		listaResultado.toList()
	}

}
