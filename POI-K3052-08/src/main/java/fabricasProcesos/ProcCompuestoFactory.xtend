package fabricasProcesos

import procesos.ProcCompuesto

class ProcCompuestoFactory implements ProcFactory{
	
	override crearProceso() {
		new ProcCompuesto()
	}
	
}