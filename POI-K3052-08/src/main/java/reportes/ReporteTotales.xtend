package reportes

import repositoriosYAdaptadores.Historial
import java.util.stream.Collectors

class ReporteTotales {

	def static generarReporte() {
		val datosHistorial = Historial.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([nombreTerminal], Collectors.summingInt([
			cantidadResultados
		])))
	}

}