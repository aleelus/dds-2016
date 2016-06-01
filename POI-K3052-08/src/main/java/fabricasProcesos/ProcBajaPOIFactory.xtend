package fabricasProcesos

import procesos.ProcBajaPoi

class ProcBajaPOIFactory implements ProcFactory{
	
	override crearProceso() {
		new ProcBajaPoi()
	}
	
}