package repositoriosYAdaptadores

import java.util.HashSet
import java.util.Set
import org.joda.time.LocalDate
import java.util.Map
import java.util.stream.Collectors
import java.util.List
import puntosDeInteres.POI

class Historial {

	/**Set de datos del historial */
	static Set<interfazUsuario.DatosBusqueda> datosBusqueda = new HashSet<interfazUsuario.DatosBusqueda>
	/**Instancia del Singleton */
	private static Historial instancia = new Historial()

	/**Defino un constructor vacío */
	new() {
	}

	def static getInstance() {
		instancia
	}

	def agregar(interfazUsuario.DatosBusqueda busqueda) {
		datosBusqueda.add(busqueda)
	}
	
	def obtenerDatos(){
		datosBusqueda
	}

	def contieneA(POI punto) {
		datosBusqueda.exists[busqueda|busqueda.listaResultados.contains(punto)]
	}

	def generarReporteFecha(interfazUsuario.Terminal terminal) {
		val Map<LocalDate, Integer> totalPorFecha = datosBusqueda.stream().collect(Collectors.groupingBy([
			fechaBusqueda
		], Collectors.summingInt([cantidadResultados])))
		totalPorFecha

	}

	def generarReporteTerminal(interfazUsuario.Terminal terminal) {
		val Map<String, List<Integer>> parcialesPorTerminal = datosBusqueda.stream().collect(Collectors.groupingBy([
			nombreTerminal
		], Collectors.mapping([cantidadResultados], Collectors.toList)))
		parcialesPorTerminal
	}

	def generarReporteTotalesTerminal(interfazUsuario.Terminal terminal) {
		val Map<String, Integer> totalPorTerminal = datosBusqueda.stream().collect(Collectors.groupingBy([
			nombreTerminal
		], Collectors.summingInt([cantidadResultados])))
		totalPorTerminal

	}

}
