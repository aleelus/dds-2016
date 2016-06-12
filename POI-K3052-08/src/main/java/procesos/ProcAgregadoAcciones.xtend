package procesos

import procesos.ProcSimple
import observers.ObserverBusqueda
import java.util.List
import repositorios.RepoUsuarios
import repositorios.DatosProceso
import org.joda.time.DateTime
import repositorios.HistorialProcesos
import algoritmosFalla.AlgoritmoFallaProceso
import interfazUsuario.Terminal

class ProcAgregadoAcciones extends ProcSimple {
	RepoUsuarios repositorioUsers
	RepoUsuarios RepoBackup
	List<ObserverBusqueda> acciones
	
	new(Terminal terminal, AlgoritmoFallaProceso algoritmo, List<ObserverBusqueda> acciones) {
		this.terminal = terminal
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
