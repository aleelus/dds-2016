package repositoriosYAdaptadores

import java.util.ArrayList
import java.util.List
import org.joda.time.DateTime

class HistorialProcesos {
	List<DatosProceso> datosProceso = new ArrayList<DatosProceso>

	/**Instancia del Singleton */
	private static HistorialProcesos instancia = new HistorialProcesos()

	/**Defino un constructor vacío */
	new() {
	}

	def static getInstance() {
		instancia
	}

	def añadirProceso(DatosProceso datos) {
		datosProceso.add(datos)
	}
}

class DatosProceso {
	DateTime tiempoEjecucion
	DateTime tiempoFinalizacion
	String proceso
	String usuario
	String resultado
	String mensajeError = new String("")

	new(DateTime ejecucion, DateTime finalizacion, String tipoProceso, String user, String resultadoProceso) {
		super()
		this.tiempoEjecucion = ejecucion
		this.tiempoFinalizacion = finalizacion
		this.proceso = tipoProceso
		this.usuario = user
		this.resultado =  resultadoProceso
	}
	
	new(DateTime ejecucion, DateTime finalizacion, String tipoProceso, String user, String resultadoProceso, String mensajeError) {
		super()
		this.tiempoEjecucion = ejecucion
		this.tiempoFinalizacion = finalizacion
		this.proceso = tipoProceso
		this.usuario = user
		this.resultado =  resultadoProceso
		this.mensajeError= mensajeError
	}
}
