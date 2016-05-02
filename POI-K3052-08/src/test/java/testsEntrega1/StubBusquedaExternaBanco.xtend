package testsEntrega1

import domain.OrigenDatos
import domain.POI
import java.util.ArrayList
import java.util.List

class StubBusquedaExternaBanco implements OrigenDatos {

	// Campos
	List<POI> listaSucursales = new ArrayList<POI>

	// Constructores
	new() {
		super()
	}

	new(List<POI> lista) {
		this()
		this.listaSucursales = lista
	}

	override search(String input) {
		listaSucursales.filter[banco|banco.nombre.contains(input)].toList
	}

}
