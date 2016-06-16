package repositorios

import interfazUsuario.DatosBusqueda
import interfazUsuario.Terminal
import java.util.List
import java.util.Map
import java.util.stream.Collectors
import org.joda.time.LocalDate
import org.uqbar.commons.model.CollectionBasedRepo
import puntosDeInteres.POI
import org.apache.commons.collections15.Predicate
import org.apache.commons.collections15.functors.AndPredicate

class HistorialBusquedas extends CollectionBasedRepo<DatosBusqueda> {

	/**Instancia del Singleton */
	private static HistorialBusquedas instancia = new HistorialBusquedas()

	/**Defino un constructor vacío */
	private new() {
	}

	def static getInstance() {
		instancia
	}

	def agregar(DatosBusqueda busqueda) {
		create(busqueda)
	}

	def obtenerDatos() {
		allInstances
	}

	def contieneA(POI punto) {
		allInstances.exists[busqueda|busqueda.listaResultados.contains(punto)]
	}

	def generarReporteFecha(Terminal terminal) {
		val Map<LocalDate, Integer> totalPorFecha = allInstances.stream().collect(Collectors.groupingBy([
			fechaBusqueda
		], Collectors.summingInt([cantidadResultados])))
		totalPorFecha

	}

	def generarReporteTerminal(Terminal terminal) {
		val Map<String, List<Integer>> parcialesPorTerminal = allInstances.stream().collect(Collectors.groupingBy([
			nombreTerminal
		], Collectors.mapping([cantidadResultados], Collectors.toList)))
		parcialesPorTerminal
	}

	def generarReporteTotalesTerminal(Terminal terminal) {
		val Map<String, Integer> totalPorTerminal = allInstances.stream().collect(Collectors.groupingBy([
			nombreTerminal
		], Collectors.summingInt([cantidadResultados])))
		totalPorTerminal

	}

	override protected Predicate<DatosBusqueda> getCriterio(DatosBusqueda dato) {
		var resultado = this.criterioTodas
		if (dato.nombreTerminal != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorTerminal(dato.nombreTerminal))
		}
		if (dato.fechaBusqueda != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorFecha(dato.fechaBusqueda))
		}
		resultado
	}

	override protected getCriterioTodas() {
		[DatosBusqueda busqueda|true] as Predicate<DatosBusqueda>
	}

	def getCriterioPorFecha(LocalDate date) {
		[DatosBusqueda dato|dato.fechaBusqueda.equals(date)] as Predicate<DatosBusqueda>
	}

	def getCriterioPorTerminal(String terminal) {
		[DatosBusqueda dato|dato.nombreTerminal.equals(terminal)] as Predicate<DatosBusqueda>
	}

	override createExample() {
		new DatosBusqueda
	}

	override getEntityType() {
		typeof(DatosBusqueda)
	}

}
