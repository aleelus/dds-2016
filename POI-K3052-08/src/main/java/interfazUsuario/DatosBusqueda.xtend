package interfazUsuario

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import puntosDeInteres.POI

@Accessors
class DatosBusqueda{

	String nombreTerminal
	long tiempoBusqueda
	int cantidadResultados
	List<POI> listaResultados
	LocalDate fechaBusqueda

	new(String nombre, LocalDate fecha, long tiempo, int cantidad, List<POI> puntos) {
		this()
		this.nombreTerminal = nombre
		this.fechaBusqueda = fecha
		this.tiempoBusqueda = tiempo
		this.cantidadResultados = cantidad
		this.listaResultados = puntos
	}

	new() {
		super()
	}
	
}
