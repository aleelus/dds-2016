package interfazUsuario

import excepciones.AuthException
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import org.uqbar.commons.utils.Observable
import reportes.ReportePorFecha
import reportes.ReportePorTerminal
import reportes.ReporteTotales
import repositoriosYAdaptadores.RepoPOI
import procesos.EjecutorProcesos

@Accessors
@Observable
class Terminal {

	String nombreTerminal
	RepoPOI repositorio
	List<ObserverBusqueda> listaObserversBus = new ArrayList<ObserverBusqueda>
	Rol rolTerminal
	EjecutorProcesos ejecutor

	new(String nombre, RepoPOI repo, Rol rol) {
		super()
		this.rolTerminal = rol
		this.nombreTerminal = nombre
		this.repositorio = repo
	}

	new() {
		super()
	}

	def search(String input) {
		val tiempoInicial = System.nanoTime()
		val datosLocales = repositorio.search(input)
		val tiempoFinal = System.nanoTime()
		val tiempoTotal = (tiempoFinal - tiempoInicial) / 1000
		val datosBusqueda = new DatosBusqueda(this.nombreTerminal, LocalDate.now, tiempoTotal, datosLocales.size,
			datosLocales)
		notificarObservadoresBusqueda(datosBusqueda)
	}

	def notificarObservadoresBusqueda(DatosBusqueda datos) {
		listaObserversBus.forEach[observer|observer.update(this, datos)]
	}

	def agregarObserverBus(ObserverBusqueda observer) {
		listaObserversBus.add(observer)
	}

	def eliminarObserver(ObserverBusqueda observer) {
		listaObserversBus.remove(observer)
	}

	def generarReporteFecha() {
		if (autorizadoAEmitirReportes) {
			ReportePorFecha.generarReporte()
		} else {
			throw new AuthException("No autorizado a emitir reporte por fecha")
		}
	}

	def generarReporteTerminal() {
		if (autorizadoAEmitirReportes) {
			ReportePorTerminal.generarReporte()
		} else {
			throw new AuthException("No autorizado a emitir reporte por terminal")
		}
	}

	def generarReporteTotalesTerminal() {
		if (autorizadoAEmitirReportes) {
			ReporteTotales.generarReporte()
		} else {
			throw new AuthException("No autorizado a emitir reporte por terminal")
		}
	}

	def seleccionarProceso(int numProceso){
		if (autorizadoAEjecutarProcesos){
			ejecutor.ejecutarProceso(numProceso)
		} else {
			throw new AuthException("No autorizado a ejecutar proceso ")
		}
	}
	
	def autorizadoAEjecutarProcesos() {
		rolTerminal.estaAutorizadoAEjecutarProcesos()
	}

	def autorizadoAEmitirNotificaciones() {
		rolTerminal.estaAutorizadoAEmitirNotificaciones()
	}

	def autorizadoAEmitirReportes() {
		rolTerminal.estaAutorizadoAEmitirReportes()
	}

}
