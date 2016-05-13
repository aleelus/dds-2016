package interfazUsuario

import java.util.List
import puntosDeInteres.POI
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class DatosBusqueda {
	
	long tiempoBusqueda
	int cantidadResultados
	List<POI> listaResultados
	
	new(long tiempo, int cantidad, List<POI> puntos) {
		this.tiempoBusqueda = tiempo
		this.cantidadResultados = cantidad
		this.listaResultados = puntos
	}
	
}