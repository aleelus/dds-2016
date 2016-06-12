package algoritmosFalla

import adaptadores.AdaptadorMails
import procesos.Proceso

class EnvioMail extends AlgoritmoFallaProceso {
	AdaptadorMails servidorMails

	override ejecutar(String usuario, Proceso proceso) {
		servidorMails.enviarMailAAdmin(usuario)
	}

}
