package builders

import algoritmosFalla.AlgoritmoFallaProceso
import excepciones.ProcessException
import interfazUsuario.Terminal
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
	
	def agregarProcActualizacionLocales(Terminal terminal, AlgoritmoFallaProceso algoritmo){
		procesoCompuesto.agregarProceso(new ProcActualizacionLocal(terminal, algoritmo))
		this
	}
	
	def agregarProcBajaPoi(Terminal terminal, AlgoritmoFallaProceso algoritmo){
		procesoCompuesto.agregarProceso(new ProcBajaPoi(terminal, algoritmo))
		this
	}
	
	def agregarProcAgregadoAcciones(Terminal terminal, AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones){
		procesoCompuesto.agregarProceso(new ProcAgregadoAcciones(terminal,algoritmo, acciones))
		this
	}
	
	def build(){
		if (procesoCompuesto.sinProcesos){
			throw new ProcessException("El proceso no tiene procesos simples")
		}
		procesoCompuesto
	}
}