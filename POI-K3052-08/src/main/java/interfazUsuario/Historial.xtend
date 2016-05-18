package interfazUsuario

import java.util.HashSet
import java.util.Set
import org.joda.time.LocalDate
import java.util.Map
import java.util.stream.Collectors
import java.util.List
import puntosDeInteres.POI

class Historial {

	/**Set de datos del historial */
	static Set<DatosBusqueda> datosBusqueda = new HashSet<DatosBusqueda>
	/**Instancia del Singleton */
	private static Historial instancia = new Historial()

	// Listas de validación
	Set<Terminal> autorizadasAReporteFecha = new HashSet<Terminal>
	Set<Terminal> autorizadasAReporteTerminal = new HashSet<Terminal>
	Set<Terminal> autorizadasAReporteTotales = new HashSet<Terminal>

	/**Defino un constructor vacío */
	new() {
	}

	def static getInstance() {
		instancia
	}

	def agregar(DatosBusqueda busqueda) {
		datosBusqueda.add(busqueda)
	}

	def contieneA(POI punto) {
		datosBusqueda.exists[busqueda|busqueda.listaResultados.contains(punto)]
	}

	def generarReporteFecha(Terminal terminal) {
		if (autorizadasAReporteFecha.contains(terminal)) {
			val Map<LocalDate, Integer> totalPorFecha = datosBusqueda.stream().collect(Collectors.groupingBy([
				fechaBusqueda
			], Collectors.summingInt([cantidadResultados])))
			totalPorFecha
		} else {
			throw new Exception("No autorizado a emitir reporte de fecha")
		}
	}

	def generarReporteTerminal(Terminal terminal) {
		if (autorizadasAReporteTerminal.contains(terminal)) {
			val Map<String, List<Integer>> parcialesPorTerminal = datosBusqueda.stream().collect(Collectors.groupingBy([
				nombreTerminal
			], Collectors.mapping([cantidadResultados], Collectors.toList)))
			parcialesPorTerminal
		} else {
			throw new Exception("No autorizado a emitir reporte de terminal")
		}

	}

	def generarReporteTotalesTerminal(Terminal terminal) {
		if (autorizadasAReporteTotales.contains(terminal)) {
			val Map<String, Integer> totalPorTerminal = datosBusqueda.stream().collect(Collectors.groupingBy([
				nombreTerminal
			], Collectors.summingInt([cantidadResultados])))
			totalPorTerminal
		} else {
			throw new Exception("No autorizado a emitir reporte de totales")
		}

	}
	
	def agregarTerminalAutorizada(Terminal terminal) {
		autorizadasAReporteFecha.add(terminal)
		autorizadasAReporteTerminal.add(terminal)
		autorizadasAReporteTotales.add(terminal)
	}
	
}
