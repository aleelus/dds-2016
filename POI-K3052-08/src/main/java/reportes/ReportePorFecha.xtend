package reportes

import java.util.stream.Collectors
import repositorios.Historial

class ReportePorFecha {

	def static generarReporte() {
		val datosHistorial = Historial.instance.obtenerDatos
		datosHistorial.stream().collect(Collectors.groupingBy([fechaBusqueda], Collectors.summingInt([
			cantidadResultados
		])))
	}

}
