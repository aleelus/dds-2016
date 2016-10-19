package repositorios

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonValue
import java.util.ArrayList
import java.util.List
import org.apache.commons.collections15.Predicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.hibernate.Criteria
import org.hibernate.HibernateException
import org.hibernate.FetchMode
import org.hibernate.criterion.Restrictions
import puntosDeInteres.POI

@Accessors
class RepoPOI extends RepoDefault<POI> implements OrigenDatos {

	/**Lista de repositorios externos */
	List<OrigenDatos> reposExterno = new ArrayList<OrigenDatos>

	/**Método para buscar puntos de interés dentro del mapa
	 * en base a un texto libre.
	 */
	override search(String input) {
		val List<POI> datosLocales = allInstances.filter[punto|punto.contieneTexto(input)].toList
		
		if (datosLocales.empty) {
			val List<POI> datosExternos = new ArrayList<POI>
			reposExterno.forEach[repo|datosExternos.addAll(repo.search(input))]
			datosLocales.addAll(datosExternos)
		}
		datosLocales
	}

	/**Método para agregar un servicio externo que implemente OrigenDeDatos a la lista */
	def agregarSrv(OrigenDatos repoExterno) {
		reposExterno.add(repoExterno)
		
	}
	
	def POI searchById(Integer id) {
		val session = openSession
		try {
			session.createCriteria(POI)
			.setFetchMode("listaComentarios", FetchMode.JOIN)
			.add(Restrictions.eq("id", id))
			.uniqueResult as POI
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
	
	
	override addQueryByExample(Criteria criteria, POI poi) {
		if (poi.id > -1) {
			criteria.add(Restrictions.eq("id", poi.id))
		}
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


	override getEntityType() {
		typeof(POI)
	}

//	override protected Predicate<POI> getCriterio(POI puntoInteres) {
//		var resultado = this.criterioTodas
//		if (puntoInteres.nombre != null) {
//			resultado = new AndPredicate(resultado, this.getCriterioPorNombre(puntoInteres.nombre))
//		}
//		resultado
//	}
//
//	override protected getCriterioTodas() {
//		[POI punto|true] as Predicate<POI>
//	}

	def getCriterioPorNombre(String nombre) {
		[POI punto|punto.nombre.equals(nombre)] as Predicate<POI>
	}
	
	def contiene(POI poi) {
		allInstances.contains(poi)
	}

	def stringJsonToList(String strJson) {

		var vec = Json.parse(strJson).asArray

		var List<String> listaCriterios = new ArrayList<String>

		for (JsonValue valor : vec) {
			listaCriterios.add(valor.asObject.getString("nombre", "undefined"))
		}

		
		listaCriterios
	}

	def buscar(String criterios) {

		var List<POI> lista = new ArrayList<POI>

		var listaCriterios = stringJsonToList(criterios)

		for (String criterio : listaCriterios) {
			lista.addAll(this.search(criterio))
		}

		lista
	}
	
	
	
	
	
	
	
		

}
