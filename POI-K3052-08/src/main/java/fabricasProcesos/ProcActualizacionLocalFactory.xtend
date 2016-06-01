package fabricasProcesos

import procesos.ProcActualizacionLocal

class ProcActualizacionLocalFactory implements ProcFactory {
	
	override crearProceso() {
		new ProcActualizacionLocal()
	}
	
}