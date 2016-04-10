package domain

import java.util.List
import java.util.ArrayList

class Mapa {
	List<POI> ListaPOI = new ArrayList()

	
	def buscar(String input){
		ListaPOI.filter[puntoInteres|puntoInteres.obtenerDatos().contains(input)]
	}
	
	}