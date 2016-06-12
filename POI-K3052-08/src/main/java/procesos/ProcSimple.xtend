package procesos

import procesos.Proceso
import excepciones.NotCompositeProcessException
import excepciones.UnsupportedProcessException
import algoritmosFalla.AlgoritmoFallaProceso
import org.eclipse.xtend.lib.annotations.Accessors
import interfazUsuario.Terminal

@Accessors
abstract class ProcSimple implements Proceso {

AlgoritmoFallaProceso algoritmoFalla
Terminal terminal
		
	override ejecutar(String nombreUsuario) {
		throw new UnsupportedProcessException("Proceso no soportado")
	}

	override agregarProceso(ProcSimple proc) {
		throw new NotCompositeProcessException(
			"No puede eliminarse un proceso de un proceso simple, debe ser compuesto")
	}

	override eliminarProceso(ProcSimple proc) {
		throw new NotCompositeProcessException(
			"No puede eliminarse un proceso de un proceso simple, debe ser compuesto")
	}

}
