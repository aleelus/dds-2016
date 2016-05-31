package interfazUsuario

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import puntosDeInteres.POI
import java.util.ArrayList

@Accessors
class DatosBusqueda{

	String nombreTerminal
	long tiempoBusqueda //en microsegundos
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

@Accessors
class ElementoReporteFechaCantidadBusq {
	LocalDate fechaBusqueda
	int cantidadResultados
	
	new(){
		super()
	}
	
	new(LocalDate fecha, int cantidad){
		this()
		this.fechaBusqueda=fecha
		this.cantidadResultados=cantidad
	}
}

@Accessors
class ElementoReporteTerminal {
	String nombreTerminal
	List<Integer> resultadosParciales = new ArrayList<Integer>
	
	new(){
		super()
	}
	
	new(String nombre){
		this()
		this.nombreTerminal = nombre
	}	
}	
