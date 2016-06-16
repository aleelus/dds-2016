package reportes

import java.util.stream.Collectors
import repositorios.HistorialBusquedas

class ReportePorFecha {

	def static generarReporte() {
		val datosHistorial = HistorialBusquedas.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([fechaBusqueda], Collectors.summingInt([
			cantidadResultados
		])))
	}

}
