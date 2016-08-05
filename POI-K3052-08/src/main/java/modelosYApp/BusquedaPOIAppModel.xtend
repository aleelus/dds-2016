package modelosYApp

import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import puntosDeInteres.POI
import repositorios.RepoPOI

@Observable
@Accessors
class BusquedaPOIAppModel {
	/**Lista de criterios activos */
	Set<String> criterios = new HashSet<String>
	/**Criterio nuevo a agregar en ventana auxiliar */
	String criterioNuevo
	/**Lista de resultados */
	Set<POI> puntosBuscados = new HashSet<POI>
	/**Repositorio de puntos de interés */
	RepoPOI repo = ApplicationContext.instance.getSingleton(typeof(POI))
	/**Punto seleccionado en la tabla */
	POI puntoSeleccionado
	/**Criterio seleccionado en la lista */
	String criterioSeleccionado
	
	
	def limpiar(){
		criterios.clear
		this.completar
	}
	
	def validarCriterios() {
		if (criterios.isNullOrEmpty){
			throw new UserException("Introduzca un criterio como mínimo")
		}
	}
	
	def buscar(){
		//puntosBuscados = criterios.stream.c
		//puntosBuscados = criterios.fold(new ArrayList<POI>,repo.search())
	}
	
	def agregarCriterio(){
		if (criterios.exists[criterio|criterio.equalsIgnoreCase(criterioNuevo)]){
			throw new UserException("El criterio ya está siendo usado")
		} else {
			criterios.add(criterioNuevo)
			criterioNuevo = null	
		}
	}
	
	def completar() {
		puntosBuscados = repo.allInstances as Set<POI>
	}
	
	def eliminarCriterio() {
		criterios.remove(criterioSeleccionado)
	}
	
}