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
	List<ObserverBusqueda> listaObserversBus = new ArrayList<ObserverBusqueda>

	new(String nombre, RepoPOI repo){
		super()
		this.nombreTerminal = nombre
		this.repositorio = repo
	}
		
	def search(String input) {
		val tiempoInicial = System.nanoTime()
		val datosLocales = repositorio.search(input)
		val tiempoFinal = System.nanoTime()
		val tiempoTotal = (tiempoFinal-tiempoInicial)/1000
		val datosBusqueda = new DatosBusqueda(this.nombreTerminal, LocalDate.now, tiempoTotal,
			datosLocales.size, datosLocales)
		notificarObservadoresBusqueda(datosBusqueda)
	}

	def notificarObservadoresBusqueda(DatosBusqueda datos) {
		listaObserversBus.forEach[observer|observer.update(datos)]
	}

	def agregarObserverBus(ObserverBusqueda observer) {
		listaObserversBus.add(observer)
	}
	
	def eliminarObserver(ObserverBusqueda observer) {
		listaObserversBus.remove(observer)
	}

	def generarReporteFecha() {
		Historial.instance.generarReporteFecha()
	}

	def generarReporteTerminal() {
		Historial.instance.generarReporteTerminal()
	}

	def generarReporteTotalesTerminal() {
		Historial.instance.generarReporteTotalesTerminal
	}

}
