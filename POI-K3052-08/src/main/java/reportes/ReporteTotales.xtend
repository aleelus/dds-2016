package reportes

import java.util.stream.Collectors
import repositorios.Historial

class ReporteTotales {

	def static generarReporte() {
		val datosHistorial = Historial.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([nombreTerminal], Collectors.summingInt([
			cantidadResultados
		])))
	}

}