package procesos

import algoritmosFalla.AlgoritmoFallaProceso
import java.util.List
import observers.ObserverBusqueda
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoUsuarios
import org.eclipse.xtend.lib.annotations.Accessors
import repositorios.ResultadoProceso

@Accessors
class ProcAgregadoAcciones extends ProcSimple {
	RepoUsuarios repositorioUsers
	RepoUsuarios repoBackup
	List<ObserverBusqueda> acciones
	List<ObserverBusqueda> ultimasAcciones

	new(String nombreVector, AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones,
		RepoUsuarios bdUsuarios) {
		this.nombre = nombreVector
		this.algoritmoFalla = algoritmo
		this.acciones = acciones
		this.repositorioUsers = bdUsuarios
	}

	override ejecutarProceso(String nombreUsuario) {
		var tiempoEjecucion = DateTime.now
		try {
			ultimasAcciones = acciones.clone
			repoBackup = repositorioUsers.clonar
			acciones.forEach[accion|repositorioUsers.agregarAccionATodos(accion)]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario, ResultadoProceso.OK))
		} catch (CloneNotSupportedException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario, ResultadoProceso.ERROR,
					"Error al hacer copia de respaldo"))
			algoritmoFalla.procesarFalla(nombreUsuario, this)
		}
	}

	def void undo(String nombreUsuario) {
		var tiempoEjecucion = DateTime.now
		repositorioUsers = repoBackup
		acciones.forEach[accion|repositorioUsers.quitarAccionATodos(accion)]
		HistorialProcesos.instance.agregarProceso(
			new DatosProceso(tiempoEjecucion, DateTime.now, "Recuperación de Repositorio de usuarios", nombreUsuario,
				ResultadoProceso.OK))
	}
}
