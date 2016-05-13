package interfazUsuario

import java.util.ArrayList
import java.util.List

class HistorialObs implements ObserverBusqueda{
	
	List<DatosBusqueda> datosBusqueda = new ArrayList<DatosBusqueda> 
	
	override update(Consulta observado, DatosBusqueda datos) {
		datosBusqueda.add(datos)
	}
	
	
	
}