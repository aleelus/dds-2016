package procesos

import adaptadores.AdaptadorServicioExterno
import algoritmosFalla.AlgoritmoFallaProceso
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoPOI

class ProcBajaPoi extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorREST
	
	new(AlgoritmoFallaProceso algoritmo) {
		this.algoritmoFalla = algoritmo
	}

	override ejecutar(String nombreUsuario) {
		val tiempoEjecucion = DateTime.now
		try {
			val listaPOIs = adaptadorREST.obtenerPOIAEliminar()
			listaPOIs.forEach[valorPoi|repositorio.search(valorPoi).forEach[poi|poi.inhabilitar]]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, "Baja de puntos de interés", nombreUsuario, "OK"))
		} catch (ClassCastException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, "Baja de puntos de interés", nombreUsuario, "ERROR",
					"Error en el archivo JSON"))
			algoritmoFalla.ejecutar(nombreUsuario, this)
		}
	}

}
