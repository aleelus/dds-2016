package interfazUsuario

class HistorialObs implements ObserverBusqueda {

	Historial historial
	
	override update(DatosBusqueda datos) {
		historial.agregar(datos)
	}

}
