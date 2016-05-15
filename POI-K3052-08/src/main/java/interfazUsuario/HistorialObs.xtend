package interfazUsuario

class HistorialObs implements ObserverBusqueda {
	
	override update(DatosBusqueda datos) {
		Historial.getInstance().agregar(datos)
	}

}
