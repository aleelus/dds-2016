package interfazUsuario

import java.util.Map
import java.time.LocalDate
import java.util.HashMap

class ReportePorFecha implements ObserverBusqueda {
	static Map<LocalDate, Integer> elementos = new HashMap<LocalDate, Integer>

	def static obtenerDatosPorFecha() {
		elementos
	}

	override update(Terminal observado, DatosBusqueda datos) {
		if (elementos.putIfAbsent(datos.fechaBusqueda, datos.cantidadResultados) != null) {
			elementos.replace(datos.fechaBusqueda, datos.cantidadResultados, datos.cantidadResultados + 1)
		}

	}

}
