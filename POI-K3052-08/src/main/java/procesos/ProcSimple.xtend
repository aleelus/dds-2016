package procesos

import algoritmosFalla.AlgoritmoFallaProceso
import excepciones.NotCompositeProcessException
import excepciones.UnsupportedProcessException
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class ProcSimple implements Proceso {

AlgoritmoFallaProceso algoritmoFalla
String nombre

		
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
