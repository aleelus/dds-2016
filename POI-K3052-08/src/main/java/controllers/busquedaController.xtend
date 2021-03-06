package controllers

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import java.util.HashMap
import java.util.Map
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.xtrest.api.Result
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils
import puntosDeInteres.Comentario
import puntosDeInteres.POI
import repositorios.RepoPOI
import repositorios.RepoUsuarios
import usuario.Terminal

@Controller
@JsonIgnoreProperties(ignoreUnknown=true)

class busquedaController {
	
	extension JSONUtils = new JSONUtils
	
	
	static RepoPOI repo	
	static RepoUsuarios usuarios

	def static void main(String[] args) {
		POIBootstrap.run()
		repo = ApplicationContext.instance.getSingleton(typeof(POI)) as RepoPOI
		usuarios = ApplicationContext.instance.getSingleton(typeof(Terminal)) as RepoUsuarios
		XTRest.start(busquedaController, 8300)
	}

	
	def String getPropertyValue(String json, String property) {
		val properties = new ObjectMapper().readValue(json, new TypeReference<HashMap<String, String>>() {
		})
		(properties as Map<String, String>).get(property)
	}

	@Post("/paginas")	
	def Result buscarCrit(@Body String listaCriterios) {
		println(listaCriterios)		
		val resultado = repo.buscar(listaCriterios)
		println(resultado.toJson)
		response.contentType = ContentType.APPLICATION_JSON
		ok(resultado.toJson)

	}


	@Post("/")	
	def validarLogin(@Body String body) {
		try {
			println(body)			
			response.contentType = ContentType.APPLICATION_JSON
			val resp = usuarios.validarLogin(body.fromJson(Terminal))
			println(resp.toJson)
			ok(resp.toJson)
		} catch (Exception ex) {
			notFound('{"error": "'+ex.toString+'"}')
			ok("false")
		}

	}
	
	
	@Put("/verdetalles/")
	def actualizarDetalles(@Body String usuario){
		try {			
			println(usuario)
			response.contentType = ContentType.APPLICATION_JSON
			val terminalUsuario = usuario.fromJson(Terminal)			
			usuarios.updateUsuario(terminalUsuario)			
			ok("true")

		} catch (Exception ex) {
			notFound('{"error": "Error al intentar marcar/desmarcar el POI como favoritos"}')
			ok("false")
		}
		
	}
	
	@Put("/verdetalles/:id")
	def actualizarComentario(@Body String comentario) {
		try {
			println(comentario)			
			val POI = repo.searchById(Integer.parseInt(id))				
			POI.addComentario(comentario.fromJson(Comentario))	
			repo.update(POI)
			response.contentType = ContentType.APPLICATION_JSON
			ok(POI.toJson)

		} catch (Exception ex) {
			notFound('{"error": "Error al comentar un POI"}')
			ok("false")
		}

	}
	

}
