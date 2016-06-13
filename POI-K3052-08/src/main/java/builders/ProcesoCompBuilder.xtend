package builders

import algoritmosFalla.AlgoritmoFallaProceso
import excepciones.ProcessException
import java.util.List
import observers.ObserverBusqueda
import procesos.ProcActualizacionLocal
import procesos.ProcAgregadoAcciones
import procesos.ProcBajaPoi
import procesos.ProcCompuesto

class ProcesoCompBuilder {
	ProcCompuesto procesoCompuesto
	
	new(){
		super()
		procesoCompuesto = new ProcCompuesto()
	}
	
	def agregarProcActualizacionLocales(AlgoritmoFallaProceso algoritmo){
		procesoCompuesto.agregarProceso(new ProcActualizacionLocal(algoritmo))
		this
	}
	
	def agregarProcBajaPoi(AlgoritmoFallaProceso algoritmo){
		procesoCompuesto.agregarProceso(new ProcBajaPoi(algoritmo))
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