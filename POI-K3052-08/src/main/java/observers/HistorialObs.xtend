package observers

import repositoriosYAdaptadores.Historial

class HistorialObs implements ObserverBusqueda {
	
	override update(interfazUsuario.Terminal terminal,interfazUsuario.DatosBusqueda datos) {
		Historial.getInstance().agregar(datos)
	}

}
