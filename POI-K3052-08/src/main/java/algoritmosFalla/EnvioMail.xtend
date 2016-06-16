package algoritmosFalla

import adaptadores.AdaptadorMails
import procesos.Proceso

class EnvioMail implements AlgoritmoFallaProceso {
	AdaptadorMails servidorMails
	
	new(AdaptadorMails srvMails){
		super()
		servidorMails = srvMails
	}

	override procesarFalla(String usuario, Proceso proceso) {
		servidorMails.enviarMailAAdmin(usuario)
	}

}
