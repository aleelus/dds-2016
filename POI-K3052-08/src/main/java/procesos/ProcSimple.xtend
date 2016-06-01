package procesos

import procesos.Proceso
import excepciones.NotCompositeProcessException
import excepciones.UnsupportedProcessException
import algoritmosFalla.AlgoritmoFallaProceso

abstract class ProcSimple implements Proceso {

AlgoritmoFallaProceso algoritmoFalla

	override ejecutar() {
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
