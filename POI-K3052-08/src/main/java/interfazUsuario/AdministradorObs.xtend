package interfazUsuario

import java.util.ArrayList
import java.util.List

class AdministradorObs implements ObserverBusqueda {

	int tiempoMaxBúsqueda = 5
	List<String> listaEmailsAdmins = new ArrayList<String> 
	

	override update(Consulta observado, DatosBusqueda datosBusqueda) {
		if (datosBusqueda.tiempoBusqueda > tiempoMaxBúsqueda) {
			enviarEmailAAdmins()		
		}
	}
	
	def enviarEmailAAdmins() {
		listaEmailsAdmins.forEach[admin | System.out.println("Mensaje enviado a "+admin)]
	}

}
