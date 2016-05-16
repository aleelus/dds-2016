package interfazUsuario

class AdministradorObs implements ObserverBusqueda {

	double tiempoMaxBúsqueda = 5
	boolean enviado 
	
	new(double tiempoMax){
		this.tiempoMaxBúsqueda=tiempoMax
	}
	
	override update(DatosBusqueda datosBusqueda) {
		enviado=false
		if (datosBusqueda.tiempoBusqueda > tiempoMaxBúsqueda) {
			enviado = true		
		}
	}

}
