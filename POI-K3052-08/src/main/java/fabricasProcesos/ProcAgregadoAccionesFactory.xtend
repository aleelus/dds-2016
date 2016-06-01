package fabricasProcesos

import procesos.ProcAgregadoAcciones

class ProcAgregadoAccionesFactory implements ProcFactory {
	
	override crearProceso() {
		new ProcAgregadoAcciones()
	}
	
}