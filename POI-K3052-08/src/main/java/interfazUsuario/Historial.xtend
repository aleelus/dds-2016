package interfazUsuario

import java.util.HashSet
import java.util.Set
import org.joda.time.LocalDate
import java.util.Map
import java.util.stream.Collectors
import java.util.List

class Historial {
	
	/**Set de datos del historial */
	static Set<DatosBusqueda> datosBusqueda = new HashSet<DatosBusqueda>
	/**Instancia del Singleton */
	private static Historial instancia = new Historial()

	/**Defino un constructor vacío */
	new() {
	}

	def static getInstance() {
		instancia
	}

	def agregar(DatosBusqueda busqueda) {
		datosBusqueda.add(busqueda)
	}
	def generarReporteFecha() {
		val Map<LocalDate, Integer> totalPorFecha = datosBusqueda.stream().collect(
			Collectors.groupingBy([fechaBusqueda], Collectors.summingInt([cantidadResultados])))
		totalPorFecha
	}

	def generarReporteTerminal() {
		val Map<String, List<Integer>> parcialesPorTerminal = datosBusqueda.stream().collect(
			Collectors.groupingBy([nombreTerminal], Collectors.mapping([cantidadResultados], Collectors.toList)))
		parcialesPorTerminal
	}

	def generarReporteTotalesTerminal() {
		val Map<String, Integer> totalPorTerminal = datosBusqueda.stream().collect(
			Collectors.groupingBy([nombreTerminal], Collectors.summingInt([cantidadResultados])))
		totalPorTerminal
	}
}
