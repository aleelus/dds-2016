package modelosYApp

import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import puntosDeInteres.POI
import repositorios.RepoPOI

@Observable
@Accessors
class BusquedaPOIAppModel{
	/**Lista de criterios activos */
	Set<String> criterios
	/**Criterio nuevo a agregar en ventana auxiliar */
	String criterioNuevo
	/**Lista de resultados */
	List<POI> puntosBuscados
	/**Repositorio de puntos de interés */
	RepoPOI repo
	/**Punto seleccionado en la tabla */
	POI puntoSeleccionado
	/**Criterio seleccionado en la lista */
	String criterioSeleccionado
	
	new(){
		puntosBuscados = new ArrayList<POI>
		repo = ApplicationContext.instance.getSingleton(typeof(POI))
		criterios = new HashSet<String>
	}
	
	
	def limpiar(){
		criterios.clear
		criterioNuevo = null
		this.completar
	}
	
	def validarCriterios() {
		if (criterios.isNullOrEmpty){
			throw new UserException("Introduzca un criterio como mínimo")
		}
	}
	
	def buscar(){
		if (!puntosBuscados.nullOrEmpty){
			puntosBuscados.clear
			puntoSeleccionado = null
			} 
		for(String criterio:criterios){
			puntosBuscados.addAll(repo.search(criterio))
		}
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
		puntosBuscados.clear
		puntoSeleccionado = null
		puntosBuscados.addAll(repo.allInstances)
	}
	
	def eliminarCriterio() {
		criterios.remove(criterioSeleccionado)
	}
	
}