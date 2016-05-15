package interfazUsuario

import java.util.HashSet
import java.util.Set

class Historial {

	/**Singleton */
	private static Historial instancia = new Historial()

	/**Defino un constructor vacío */
	new() {
	}

	def static getInstance() {
		instancia
	}

	static Set<DatosBusqueda> datosBusqueda = new HashSet<DatosBusqueda>

	def agregar(DatosBusqueda busqueda) {
		datosBusqueda.add(busqueda)
	}

	def obtenerReporteFechaCantidad() {
		val Set<ElementoReporteFechaCantidadBusq> listaElementos = new HashSet<ElementoReporteFechaCantidadBusq>
		datosBusqueda.forEach[elemento|agregarElementoReporteFecha(elemento, listaElementos)]
		listaElementos
	}

	def agregarElementoReporteFecha(DatosBusqueda elementoHistorial,
		Set<ElementoReporteFechaCantidadBusq> listElementos) {
		val elementoReporte = new ElementoReporteFechaCantidadBusq(elementoHistorial.fechaBusqueda,
			elementoHistorial.cantidadResultados)
		if (!listElementos.exists[elemento|elemento.fechaBusqueda == elementoReporte.fechaBusqueda]) {
			listElementos.add(elementoReporte)
		} else {
			var primerElemento = listElementos.findFirst [ elemento |
				elemento.fechaBusqueda == elementoReporte.fechaBusqueda
			]
			primerElemento.cantidadResultados = primerElemento.cantidadResultados + elementoReporte.cantidadResultados
		}

	}

	def obtenerReporteTerminal() {
		val Set<ElementoReporteTerminal> listaResultados = new HashSet<ElementoReporteTerminal>
		datosBusqueda.forEach[elemento|agregarElementoTerminal(elemento, listaResultados)]
		listaResultados
	}

	def agregarElementoTerminal(DatosBusqueda elementoHistorial, Set<ElementoReporteTerminal> listaElementos) {
		val elementoReporte = new ElementoReporteTerminal(elementoHistorial.nombreTerminal)
		if (!listaElementos.exists[elemento|elemento.nombreTerminal == elementoReporte.nombreTerminal]) {
			elementoReporte.resultadosParciales.add(elementoHistorial.cantidadResultados)
			listaElementos.add(elementoReporte)
		} else {
			var primerElemento = listaElementos.findFirst [ elemento |
				elemento.nombreTerminal == elementoReporte.nombreTerminal
			]
			primerElemento.resultadosParciales.add(elementoHistorial.cantidadResultados)
		}
	}

}
