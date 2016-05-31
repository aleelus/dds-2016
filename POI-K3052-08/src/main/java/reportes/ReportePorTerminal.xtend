package reportes

import java.util.stream.Collectors
import repositoriosYAdaptadores.Historial

class ReportePorTerminal {

	def static generarReporte() {
		val datosHistorial = Historial.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([
			nombreTerminal
		], Collectors.mapping([cantidadResultados], Collectors.toList)))
	}

}
