package adaptadores

import java.util.List
import java.util.ArrayList

class AdaptadorMails {
	
	InterfazAdmin mailAdmin
	List<String> emisoresMails = new ArrayList<String>
	
	new(InterfazAdmin admin){
		super()
		this.mailAdmin = admin
	}
	
	def enviarMailAAdmins(String nombre,long tiempo) {
		if(mailAdmin.recibirMail(nombre, tiempo)){
			emisoresMails.add(nombre)
		} else {
			throw new Exception("Error en envío de mail")
		}
	}
	
	def contieneMail(String nombreTerminal) {
		emisoresMails.contains(nombreTerminal)
	}
	
}

interface InterfazAdmin {
	def boolean recibirMail(String terminal, long tiempoBusqueda)
	
	def boolean comprobarMail(String string)
}
