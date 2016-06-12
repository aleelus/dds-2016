package algoritmosFalla

import algoritmosFalla.AlgoritmoFallaProceso
import procesos.Proceso

class ReintentarProceso extends AlgoritmoFallaProceso {

	int cantidad
	
	new(int cantidadReintentos){
		this.cantidad= cantidadReintentos
	}
	
	override ejecutar(String usuario, Proceso proceso) {
		if (cantidad>0){
			cantidad--
			proceso.ejecutar(usuario)
		}
	}
	
}