package modelosYApp

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.Observable
import puntosDeInteres.POI
import org.uqbar.commons.utils.ApplicationContext
import repositorios.RepoPOI

@Observable
@Accessors
class BusquedaPOIAppModel {
	List<String> criterios = new ArrayList<String>
	List<POI> puntosBuscados = new ArrayList<POI>
	RepoPOI repo = ApplicationContext.instance.getSingleton(typeof(POI))
	POI puntoSeleccionado
	
	def limpiar(){
		criterios.clear
		puntosBuscados.clear
	}
	
	def validarCriterios() {
		if (criterios.isNullOrEmpty){
			throw new UserException("Introduzca un criterio como mínimo")
		}
	}
	
	def completar() {
		puntosBuscados = repo.allInstances
	}
	
}