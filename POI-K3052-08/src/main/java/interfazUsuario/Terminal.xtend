package interfazUsuario

import java.time.LocalDate
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable
import repositoriosYAdaptadores.RepoPOI

@Accessors
@Observable
class Terminal {

	String nombreTerminal
	RepoPOI repositorio
	List<ObserverBusqueda> listaObservers = new ArrayList<ObserverBusqueda>

	def search(String input) {
		val tiempoInicial = System.nanoTime()
		val datosLocales = repositorio.search(input)
		val tiempoFinal = System.nanoTime()
		val datosBusqueda = new DatosBusqueda(this.nombreTerminal, LocalDate.now, tiempoFinal - tiempoInicial,
			datosLocales.size, datosLocales)
		notificarObservadores(datosBusqueda)
	}

	def notificarObservadores(DatosBusqueda datos) {
		listaObservers.forEach[observer|observer.update(this, datos)]
	}

	def agregarObserver(ObserverBusqueda observer) {
		listaObservers.add(observer)
	}
	
	def obtenerReporteFecha(){
		ReportePorFecha.obtenerDatosPorFecha()
	}
	
	def obetenerReporteTerminal(){
		ReportePorTerminal.obtenerDatosPorTerminal()
	}
	
}