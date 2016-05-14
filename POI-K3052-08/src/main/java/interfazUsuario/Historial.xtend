package interfazUsuario

import java.util.Set
import java.util.HashSet

class Historial {
	
	/**Singleton */
	private static Historial instancia = new Historial()
	
	/**Defino un constructor vacío */
	new(){
	}
	
	
	def getInstance(){
		instancia
	}
	
	static Set<DatosBusqueda> datosBusqueda = new HashSet<DatosBusqueda>
	
	def agregar(DatosBusqueda busqueda) {
		datosBusqueda.add(busqueda)
	}
		
}