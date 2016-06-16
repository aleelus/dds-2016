package observers

import repositorios.HistorialBusquedas

class HistorialObs implements ObserverBusqueda {
	
	override update(interfazUsuario.Terminal terminal,interfazUsuario.DatosBusqueda datos) {
		HistorialBusquedas.getInstance().agregar(datos)
	}

}
