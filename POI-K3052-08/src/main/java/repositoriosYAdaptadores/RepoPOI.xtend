package repositoriosYAdaptadores

import org.apache.commons.collections15.Predicate
import org.apache.commons.collections15.functors.AndPredicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.CollectionBasedRepo
import puntosDeInteres.POI
import java.util.List
import java.util.ArrayList

@Accessors
class RepoPOI extends CollectionBasedRepo<POI> implements OrigenDatos {

	/**Lista de repositorios externos */
	List<OrigenDatos> reposExterno = new ArrayList<OrigenDatos>
	/**Instancia que convierte al repositorio en Singleton */
//	static RepoPOI instancia = null
//
//	/**Evita la construcción de nuevos objetos de la misma clase */
//	private new(){}
//	
//	/**Método para obtener la única instancia del repositorio */
//	static def RepoPOI getInstancia(){
//		if (instancia==null){
//			instancia = new RepoPOI
//		}
//		instancia
//	}
	
	/**Método para buscar puntos de interés dentro del mapa
	 * en base a un texto libre.
	 */
	override search(String input) {

		val List<POI> datosLocales = allInstances.filter[punto|punto.contieneTexto(input)].toList
		val List<POI> datosExternos = new ArrayList<POI>
		reposExterno.forEach[repo| datosExternos.addAll(repo.search(input))]
		datosLocales.addAll(datosExternos)
		datosLocales
	}
	
	def agregarSrv(OrigenDatos repoExterno){
		reposExterno.add(repoExterno)
	}
	
	override create(POI puntoInteres) {
		super.create(puntoInteres)
	}

	override delete(POI puntoInteres) {
		if (!allInstances.contains(puntoInteres)) {
			throw new Exception("El Punto de interés especificado no existe")
		}
		super.delete(puntoInteres)
	}

	override update(POI puntoInteres) {
		if (!allInstances.contains(puntoInteres)) {
			throw new Exception("El Punto de interés especificado no existe")
		}
		puntoInteres.validateCreate()
		super.update(puntoInteres)
	}

	override createExample() {
		new POI
	}

	override getEntityType() {
		typeof(POI)
	}

	override protected Predicate<POI> getCriterio(POI puntoInteres) {
		var resultado = this.criterioTodas
		if (puntoInteres.nombre != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorNombre(puntoInteres.nombre))
		}
		resultado
	}

	override protected getCriterioTodas() {
		[POI punto|true] as Predicate<POI>
	}

	def getCriterioPorNombre(String nombre) {
		[POI punto|punto.nombre.equals(nombre)]
	}

}
