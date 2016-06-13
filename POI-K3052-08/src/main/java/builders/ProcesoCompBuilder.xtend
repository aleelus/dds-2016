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
	
	def agregarProcAgregadoAcciones(AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones){
		procesoCompuesto.agregarProceso(new ProcAgregadoAcciones(algoritmo, acciones))
		this
	}
	
	def build(){
		if (procesoCompuesto.sinProcesos){
			throw new ProcessException("El proceso no tiene procesos simples")
		}
		procesoCompuesto
	}
}