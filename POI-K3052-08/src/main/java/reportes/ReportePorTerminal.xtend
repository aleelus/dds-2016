package reportes

import java.util.stream.Collectors
import repositorios.HistorialBusquedas

class ReportePorTerminal {

	def static generarReporte() {
		val datosHistorial = HistorialBusquedas.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([
			nombreTerminal
		], Collectors.mapping([cantidadResultados], Collectors.toList)))
	}

}
