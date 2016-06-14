package procesos

import algoritmosFalla.AlgoritmoFallaProceso
import java.util.List
import observers.ObserverBusqueda
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoUsuarios
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProcAgregadoAcciones extends ProcSimple {
	RepoUsuarios repositorioUsers
	RepoUsuarios RepoBackup
	List<ObserverBusqueda> acciones
	
	new(String nombreVector, AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones, RepoUsuarios bdUsuarios) {
		this.nombre = nombreVector
		this.algoritmoFalla = algoritmo
		this.acciones = acciones
		this.repositorioUsers = bdUsuarios
	}

	override ejecutar(String nombreUsuario) {
		var tiempoEjecucion = DateTime.now
		try {
			RepoBackup = repositorioUsers.clone() as RepoUsuarios
			acciones.forEach[accion|repositorioUsers.agregarAccionATodos(accion)]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario, "OK"))
		} catch (CloneNotSupportedException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, nombre, nombreUsuario, "ERROR",
					"Error al hacer copia de respaldo"))
			algoritmoFalla.ejecutar(nombreUsuario, this)
		}
	}

	def undo(String nombreUsuario) {
		var tiempoEjecucion = DateTime.now
		repositorioUsers = RepoBackup
		new DatosProceso(tiempoEjecucion, DateTime.now, "Recuperación de Repositorio de usuarios", nombreUsuario, "OK")
	}
}
