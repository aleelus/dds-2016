package observers


import excepciones.AuthException
import adaptadores.AdaptadorMails
import usuario.Terminal
import usuario.DatosBusqueda

class AdministradorObs implements ObserverBusqueda {

	double tiempoMaxBúsqueda
	AdaptadorMails servidorMails

	new(double tiempoMax, AdaptadorMails servidor) {
		this.tiempoMaxBúsqueda = tiempoMax
		this.servidorMails = servidor
	}

	def actualizarTiempo(double tiempoMax) {
		this.tiempoMaxBúsqueda = tiempoMax
	}

	override update(Terminal terminal, DatosBusqueda datosBusqueda) {
		if (datosBusqueda.tiempoBusqueda >= tiempoMaxBúsqueda) {
			if (terminal.autorizadoAEmitirNotificaciones) {
				servidorMails.enviarMailAAdmins(datosBusqueda.nombreTerminal, datosBusqueda.tiempoBusqueda)
			} else {
				throw new AuthException("No autorizado a enviar notificaciones")
			}
		}
	}

}
