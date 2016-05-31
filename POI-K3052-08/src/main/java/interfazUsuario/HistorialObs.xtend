package interfazUsuario

import repositoriosYAdaptadores.Historial

class HistorialObs implements ObserverBusqueda {
	
	override update(Terminal terminal,DatosBusqueda datos) {
		Historial.getInstance().agregar(datos)
	}

}
