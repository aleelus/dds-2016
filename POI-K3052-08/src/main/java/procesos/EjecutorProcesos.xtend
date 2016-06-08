package procesos

import fabricasProcesos.ProcActualizacionLocalFactory
import fabricasProcesos.ProcAgregadoAccionesFactory
import fabricasProcesos.ProcFactory
import java.util.Map
import fabricasProcesos.ProcBajaPOIFactory
import fabricasProcesos.ProcCompuestoFactory
import repositoriosYAdaptadores.HistorialProcesos

class EjecutorProcesos {
	Map<Integer, ProcFactory> dictProcesos = newLinkedHashMap(
		1 -> (new ProcActualizacionLocalFactory), 
		2 -> (new ProcAgregadoAccionesFactory),
		3 -> (new ProcBajaPOIFactory),
		4 -> (new ProcCompuestoFactory)
	)

	def crearProceso(int i) {
		dictProcesos.get(i).crearProceso
	}
	
	def ejecutarProceso(Proceso proceso, String nombreUsuario){
		val historial = HistorialProcesos.instance
		historial.agregarProceso(proceso.ejecutar(nombreUsuario))
	}
	
}
