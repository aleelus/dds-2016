package procesos

import algoritmosFalla.AlgoritmoFallaProceso
import java.util.List
import observers.ObserverBusqueda
import org.joda.time.DateTime
import repositorios.DatosProceso
import repositorios.HistorialProcesos
import repositorios.RepoUsuarios

class ProcAgregadoAcciones extends ProcSimple {
	RepoUsuarios repositorioUsers
	RepoUsuarios RepoBackup
	List<ObserverBusqueda> acciones
	
	new(AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones) {
		this.algoritmoFalla = algoritmo
		this.acciones = acciones
	}

	override ejecutar(String nombreUsuario) {
		var tiempoEjecucion = DateTime.now
		RepoBackup = repositorioUsers.clone() as RepoUsuarios
		try {
			acciones.forEach[accion|repositorioUsers.agregarAccionATodos(accion)]
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, "Adición masiva de acciones", nombreUsuario, "OK"))
		} catch (CloneNotSupportedException e) {
			HistorialProcesos.instance.agregarProceso(
				new DatosProceso(tiempoEjecucion, DateTime.now, "Adición masiva de acciones", nombreUsuario, "ERROR",
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
