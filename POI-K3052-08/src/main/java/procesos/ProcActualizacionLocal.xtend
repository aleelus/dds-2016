package procesos

import java.util.List
import repositoriosYAdaptadores.RepoPOI
import repositoriosYAdaptadores.DatosProceso
import org.joda.time.DateTime
import repositoriosYAdaptadores.HistorialProcesos
import java.io.IOException
import adaptadores.AdaptadorServicioExterno

class ProcActualizacionLocal extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorArchivo

	override ejecutar(String nombreUsuario) {

		val tiempoEjecucion = DateTime.now
		var DatosProceso resultado
		try {
			val archivoProcesado = adaptadorArchivo.procesarArchivoAct
			archivoProcesado.forEach[nombreLocal, tags|procesarLinea(nombreLocal, tags)]
			resultado = new DatosProceso(tiempoEjecucion, DateTime.now, "Actualización de locales comerciales",
				nombreUsuario, "OK")
		} catch (IOException e) {
			resultado = new DatosProceso(tiempoEjecucion, DateTime.now, "Actualización de locales comerciales",
				nombreUsuario, "ERROR","No pudo leerse correctamente el archivo")
		} finally {
			HistorialProcesos.instance.agregarProceso(resultado)
		}
	}

	def procesarLinea(String nombreLocal, List<String> tags) {
		val pois = repositorio.search(nombreLocal)
		if (!pois.isEmpty) {
			pois.forEach[poi|poi.tags = tags]
		}
	}

}
