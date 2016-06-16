package procesos

import adaptadores.AdaptadorServicioExterno
import algoritmosFalla.AlgoritmoFallaProceso
import java.io.IOException
import java.util.List
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoPOI
import org.eclipse.xtend.lib.annotations.Accessors
import repositorios.ResultadoProceso

@Accessors
class ProcActualizacionLocal extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorArchivo
	
	new(String nombre,AlgoritmoFallaProceso algoritmo, RepoPOI repoOrigen, AdaptadorServicioExterno srvExt) {
		this.nombre = nombre
		this.algoritmoFalla = algoritmo
		this.repositorio = repoOrigen
		this.adaptadorArchivo = srvExt
	}

	override ejecutarProceso(String nombreUsuario) {

		val tiempoEjecucion = DateTime.now
		try {
			val archivoProcesado = adaptadorArchivo.procesarArchivoAct
			archivoProcesado.forEach[nombreLocal, tags|procesarLinea(nombreLocal, tags)]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario,
					ResultadoProceso.OK))
		} catch (IOException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario,
					ResultadoProceso.ERROR, "No pudo leerse correctamente el archivo"))
			algoritmoFalla.procesarFalla(nombreUsuario, this)
		}
	}

	def procesarLinea(String nombreLocal, List<String> tags) {
		val pois = repositorio.search(nombreLocal)
		if (!pois.isEmpty) {
			pois.forEach[poi|poi.tags = tags]
		}
	}

}
