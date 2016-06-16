package reportes

import java.util.stream.Collectors
import repositorios.HistorialBusquedas

class ReporteTotales {

	def static generarReporte() {
		val datosHistorial = HistorialBusquedas.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([nombreTerminal], Collectors.summingInt([
			cantidadResultados
		])))
	}

}