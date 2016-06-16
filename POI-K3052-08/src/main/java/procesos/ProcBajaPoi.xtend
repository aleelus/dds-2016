package procesos

import adaptadores.AdaptadorServicioExterno
import algoritmosFalla.AlgoritmoFallaProceso
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoPOI
import org.eclipse.xtend.lib.annotations.Accessors
import repositorios.ResultadoProceso

@Accessors
class ProcBajaPoi extends ProcSimple {
	RepoPOI repositorio
	AdaptadorServicioExterno adaptadorREST
	
	new(String nomProceso, AlgoritmoFallaProceso algoritmo, RepoPOI repoOrigen, AdaptadorServicioExterno srvExt) {
		this.nombre = nomProceso
		this.algoritmoFalla = algoritmo
		this.repositorio = repoOrigen
		this.adaptadorREST = srvExt
	}

	override ejecutarProceso(String nombreUsuario) {
		val tiempoEjecucion = DateTime.now
		try {
			val listaPOIs = adaptadorREST.obtenerPOIAEliminar()
			listaPOIs.forEach[valorPoi|repositorio.search(valorPoi).forEach[poi|poi.inhabilitar]]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario, ResultadoProceso.OK))
		} catch (ClassCastException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario, ResultadoProceso.ERROR,
					"Error en el archivo JSON"))
			algoritmoFalla.procesarFalla(nombreUsuario, this)
		}
	}

}
