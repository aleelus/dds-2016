package algoritmosFalla

import adaptadores.AdaptadorMails
import procesos.Proceso

class EnvioMail extends AlgoritmoFallaProceso {
	AdaptadorMails servidorMails
	
	new(AdaptadorMails srvMails){
		super()
		servidorMails = srvMails
	}

	override ejecutar(String usuario, Proceso proceso) {
		servidorMails.enviarMailAAdmin(usuario)
	}

}
