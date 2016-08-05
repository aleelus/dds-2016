package usuario

import excepciones.AuthException
import java.util.ArrayList
import java.util.List
import observers.ObserverBusqueda
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import org.uqbar.commons.model.Entity
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import procesos.ProcAgregadoAcciones
import procesos.Proceso
import reportes.ReportePorFecha
import reportes.ReportePorTerminal
import reportes.ReporteTotales
import repositorios.RepoPOI
import puntosDeInteres.POI

@Accessors
@Observable
class Terminal extends Entity{

	String nombreTerminal
	String contraseña 
	List<ObserverBusqueda> listaObservers = new ArrayList<ObserverBusqueda>
	Rol rolTerminal
	RepoPOI repositorio = ApplicationContext.instance.getRepo(typeof(POI)) as RepoPOI

	new(String nombre, Rol rol) {
		super()
		this.rolTerminal = rol
		this.nombreTerminal = nombre
	}

	new() {
		super()
	}
	
	new(Terminal terminal) {
		this()
		this.rolTerminal = terminal.rolTerminal
		this.nombreTerminal = terminal.nombreTerminal
		this.listaObservers = terminal.listaObservers
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
		listaObservers.forEach[observer|observer.update(this,datos)]
	}

	def agregarObserver(ObserverBusqueda observer) {
		listaObservers.add(observer)
	}

	def eliminarObserver(ObserverBusqueda observer) {
		listaObservers.remove(observer)
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

	def ejecutarProceso(Proceso proceso){
		if (autorizadoAEjecutarProcesos){
			proceso.ejecutarProceso(this.nombreTerminal)
		} else {
			throw new AuthException("No autorizado a crear proceso")
		}
	}
	
	def deshacerProcesoAcciones(ProcAgregadoAcciones proceso){
		if (autorizadoAEjecutarProcesos){
			proceso.undo(this.nombreTerminal)
		} else {
			throw new AuthException("No autorizado a crear proceso")
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
	
	def tieneCantObservers(int i) {
		listaObservers.size.equals(i)
	}
	
	def TieneAcciones(List<ObserverBusqueda> acciones) {
		acciones.forall[accion | listaObservers.contains(accion)]
	}

}
