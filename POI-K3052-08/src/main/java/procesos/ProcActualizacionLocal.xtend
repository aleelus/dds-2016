package procesos

import adaptadores.AdaptadorServicioExterno
import algoritmosFalla.AlgoritmoFallaProceso
import java.io.IOException
import java.util.List
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoPOI

class ProcActualizacionLocal extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorArchivo
	
	new(AlgoritmoFallaProceso algoritmo) {
		this.algoritmoFalla = algoritmo
	}

	override ejecutar(String nombreUsuario) {

		val tiempoEjecucion = DateTime.now
		try {
			val archivoProcesado = adaptadorArchivo.procesarArchivoAct
			archivoProcesado.forEach[nombreLocal, tags|procesarLinea(nombreLocal, tags)]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, "Actualización de locales comerciales", nombreUsuario,
					"OK"))
		} catch (IOException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, "Actualización de locales comerciales", nombreUsuario,
					"ERROR", "No pudo leerse correctamente el archivo"))
			algoritmoFalla.ejecutar(nombreUsuario, this)
		}
	}

	def procesarLinea(String nombreLocal, List<String> tags) {
		val pois = repositorio.search(nombreLocal)
		if (!pois.isEmpty) {
			pois.forEach[poi|poi.tags = tags]
		}
	}

}
