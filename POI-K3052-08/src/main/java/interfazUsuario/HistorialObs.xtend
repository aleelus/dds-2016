package interfazUsuario

import java.util.HashSet
import java.util.Set

class HistorialObs implements ObserverBusqueda {

	static Set<DatosBusqueda> datosBusqueda = new HashSet<DatosBusqueda>

	override update(Terminal observado, DatosBusqueda datos) {
		datosBusqueda.add(datos)
	}

}
