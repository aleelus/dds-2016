package procesos

import repositoriosYAdaptadores.RepoPOI
import org.joda.time.DateTime
import repositoriosYAdaptadores.DatosProceso
import repositoriosYAdaptadores.HistorialProcesos
import adaptadores.AdaptadorServicioExterno

class ProcBajaPoi extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorREST

	override ejecutar(String nombreUsuario) {
		val tiempoEjecucion = DateTime.now
		var DatosProceso resultado
		try {
			val listaPOIs = adaptadorREST.obtenerPOIAEliminar()
			listaPOIs.forEach[valorPoi|repositorio.search(valorPoi).forEach[poi|poi.inhabilitar]]
			resultado = new DatosProceso(tiempoEjecucion, DateTime.now, "Baja de puntos de interés", nombreUsuario, "OK")
		}
		catch (ClassCastException e){
			resultado = new DatosProceso(tiempoEjecucion, DateTime.now, "Baja de puntos de interés", nombreUsuario, "ERROR", "Error en el archivo JSON")
		}
		finally{
			HistorialProcesos.instance.agregarProceso(resultado);
		}
	}

}
