package interfazUsuario

import org.joda.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors

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