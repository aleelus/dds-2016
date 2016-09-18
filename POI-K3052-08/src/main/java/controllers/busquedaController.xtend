package controllers

import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import java.util.HashMap
import java.util.Map
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.xtrest.api.Result
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils
import puntosDeInteres.POI
import repositorios.RepoPOI
import repositorios.RepoUsuarios
import usuario.Terminal

@Controller
class busquedaController {

	extension JSONUtils = new JSONUtils
	
	static RepoPOI repo
	
	//

	def static void main(String[] args) {

		POIBootstrap.run()
		repo = ApplicationContext.instance.getSingleton(typeof(POI)) as RepoPOI
		XTRest.start(busquedaController, 9000)

	}

	def String getPropertyValue(String json, String property) {
		val properties = new ObjectMapper().readValue(json, new TypeReference<HashMap<String, String>>() {
		})
		(properties as Map<String, String>).get(property)
	}
	
	
	

	@Post("/paginas")
	def Result buscarCrit(@Body String listaCriterios) {
		println(listaCriterios)
		val resultado = repo.buscar(listaCriterios).toJson		
		println(resultado)

		response.contentType = ContentType.APPLICATION_JSON
		ok(resultado)

	}

	@Get("/")
	def validarLogin(@Body String body) {
		try {
			val usuarios = ApplicationContext.instance.getSingleton(typeof(Terminal)) as RepoUsuarios
			response.contentType = ContentType.APPLICATION_JSON
			ok(usuarios.validarLogin(body.fromJson(Terminal)).toJson)
		} catch (Exception ex) {
			notFound('{"error": "'+ex.toString+'"}')
		}

	}

	def busquedas() {
	}

}
