package testsEntrega1

import domain.OrigenDatos
import domain.SucursalBanco
import java.util.List

class StubBusquedaExternaBanco implements OrigenDatos {
	
	//Campos
	List<SucursalBanco> listaSucursales
	
	//Constructores
	new(){
		super()
	}
	
	new(List<SucursalBanco> lista){
		this()
		this.listaSucursales=lista
	}
	
	override search(String input) {
		//Definir listado. ALE
	}
	
}