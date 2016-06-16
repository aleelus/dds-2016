package algoritmosFalla

import algoritmosFalla.AlgoritmoFallaProceso
import procesos.Proceso

class ReintentarProceso implements AlgoritmoFallaProceso {

	int cantidad
	
	new(int cantidadReintentos){
		super()
		this.cantidad= cantidadReintentos
	}
	
	override procesarFalla(String usuario, Proceso proceso) {
		if (cantidad>0){
			cantidad--
			proceso.ejecutarProceso(usuario)
		}
	}
	
}