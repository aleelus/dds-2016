package repositorios

import java.util.ArrayList
import java.util.List
import org.joda.time.DateTime
import interfazUsuario.Terminal
import org.eclipse.xtend.lib.annotations.Accessors
import procesos.ProcAgregadoAcciones

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

	def agregarProceso(DatosProceso proceso) {
		datosProceso.add(proceso)
	}

	def contieneAOK(Terminal terminal) {
		datosProceso.exists [resultado |
			resultado.resultado.equalsIgnoreCase("OK") && resultado.usuario.equals(terminal.nombreTerminal)
		]
	}

	def contieneAEror(Terminal terminal) {
		datosProceso.exists [resultado |
			resultado.resultado.equalsIgnoreCase("ERROR") && resultado.usuario.equals(terminal.nombreTerminal)
		]
	}

	def contieneErrorDeProceso(Terminal terminal, ProcAgregadoAcciones proceso) {
		datosProceso.exists [resultado |
			resultado.resultado.equalsIgnoreCase("ERROR") && resultado.usuario.equals(terminal.nombreTerminal) &&
				resultado.proceso.equals(proceso.nombre)
		]
	}

}

@Accessors
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
		this.resultado = resultadoProceso
	}

	new(DateTime ejecucion, DateTime finalizacion, String tipoProceso, String user, String resultadoProceso,
		String mensajeError) {
		super()
		this.tiempoEjecucion = ejecucion
		this.tiempoFinalizacion = finalizacion
		this.proceso = tipoProceso
		this.usuario = user
		this.resultado = resultadoProceso
		this.mensajeError = mensajeError
	}
}
