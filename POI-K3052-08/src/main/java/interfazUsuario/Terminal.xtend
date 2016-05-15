package interfazUsuario

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable
import repositoriosYAdaptadores.RepoPOI
import org.joda.time.LocalDate

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
		listaObservers.forEach[observer|observer.update(datos)]
	}

	def agregarObserver(ObserverBusqueda observer) {
		listaObservers.add(observer)
	}

	def eliminarObserver(ObserverBusqueda observer) {
		listaObservers.remove(observer)
	}

	def obtenerReporteFechaCantidad() {
		Historial.instance.obtenerReporteFechaCantidad()
	}
	
	def obtenerReporteTerminal(){
		Historial.instance.obtenerReporteTerminal()
	}

}
