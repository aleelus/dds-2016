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
	
	def agregarProcActualizacionLocales(AlgoritmoFallaProceso algoritmo, RepoPOI repoOrigen, AdaptadorServicioExterno srvExt){
		procesoCompuesto.agregarProceso(new ProcActualizacionLocal(algoritmo, repoOrigen, srvExt))
		this
	}
	
	def agregarProcBajaPoi(AlgoritmoFallaProceso algoritmo, RepoPOI repoOrigen, AdaptadorServicioExterno srvExt){
		procesoCompuesto.agregarProceso(new ProcBajaPoi(algoritmo, repoOrigen, srvExt))
		this
	}
	
	def agregarProcAgregadoAcciones(AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones, RepoUsuarios bdUsuarios){
		procesoCompuesto.agregarProceso(new ProcAgregadoAcciones(algoritmo, acciones, bdUsuarios))
		this
	}
	
	def build(){
		if (procesoCompuesto.sinProcesos){
			throw new ProcessException("El proceso no tiene procesos simples")
		}
		procesoCompuesto
	}
}