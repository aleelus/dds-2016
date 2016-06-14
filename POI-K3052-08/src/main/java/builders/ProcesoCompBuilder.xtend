package builders

import algoritmosFalla.AlgoritmoFallaProceso
import excepciones.ProcessException
import java.util.List
import observers.ObserverBusqueda
import procesos.ProcActualizacionLocal
import procesos.ProcAgregadoAcciones
import procesos.ProcBajaPoi
import procesos.ProcCompuesto
import repositorios.RepoPOI
import adaptadores.AdaptadorServicioExterno
import repositorios.RepoUsuarios

class ProcesoCompBuilder {
	ProcCompuesto procesoCompuesto
	
	new(){
		super()
		procesoCompuesto = new ProcCompuesto()
	}
	
	def agregarProcActualizacionLocales(String nombre,AlgoritmoFallaProceso algoritmo, RepoPOI repoOrigen, AdaptadorServicioExterno srvExt){
		procesoCompuesto.agregarProceso(new ProcActualizacionLocal(nombre,algoritmo, repoOrigen, srvExt))
		this
	}
	
	def agregarProcBajaPoi(String nombre,AlgoritmoFallaProceso algoritmo, RepoPOI repoOrigen, AdaptadorServicioExterno srvExt){
		procesoCompuesto.agregarProceso(new ProcBajaPoi(nombre,algoritmo, repoOrigen, srvExt))
		this
	}
	
	def agregarProcAgregadoAcciones(String nombre,AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones, RepoUsuarios bdUsuarios){
		procesoCompuesto.agregarProceso(new ProcAgregadoAcciones(nombre,algoritmo, acciones, bdUsuarios))
		this
	}
	
	def build(){
		if (procesoCompuesto.sinProcesos){
			throw new ProcessException("El proceso no tiene procesos simples")
		}
		procesoCompuesto
	}
}