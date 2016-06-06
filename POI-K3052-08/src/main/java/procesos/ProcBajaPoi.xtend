package procesos

import repositoriosYAdaptadores.RepoPOI
import repositoriosYAdaptadores.AdaptadorServicioExterno
import org.joda.time.DateTime
import repositoriosYAdaptadores.DatosProceso

class ProcBajaPoi extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorREST

	override ejecutar(String nombreUsuario) {
		val tiempoEjecucion = DateTime.now
		val listaPOIs = adaptadorREST.obtenerPOIAEliminar()
		listaPOIs.forEach[valorPoi|repositorio.search(valorPoi).forEach[poi|poi.inhabilitar]]
		new DatosProceso(tiempoEjecucion, DateTime.now, "Baja de puntos de interés", nombreUsuario, "OK")
	}

}
