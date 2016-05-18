package interfazUsuario

class AdministradorObs implements ObserverBusqueda {

	double tiempoMaxBúsqueda
	boolean enviado 
	
	new(double tiempoMax){
		this.tiempoMaxBúsqueda=tiempoMax
	}
	
	def actualizarTiempo(double tiempoMax){
		this.tiempoMaxBúsqueda = tiempoMax
	}
	
	override update(DatosBusqueda datosBusqueda) {
		enviado=false
		if (datosBusqueda.tiempoBusqueda >= tiempoMaxBúsqueda) {
			enviado = true		
		}
	}
	
	def envioMail() {
		enviado
	}

}
