package observers

import repositorios.HistorialBusquedas
import usuario.Terminal
import usuario.DatosBusqueda

class HistorialObs implements ObserverBusqueda {
	
	override update(Terminal terminal,DatosBusqueda datos) {
		HistorialBusquedas.getInstance().agregar(datos)
	}

}
