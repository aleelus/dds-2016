package controllers


import com.fasterxml.jackson.annotation.JsonIgnoreProperties
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
@JsonIgnoreProperties(ignoreUnknown=true)
class busquedaController {

	extension JSONUtils = new JSONUtils
	
	
	static RepoPOI repo	
	static RepoUsuarios usuarios

	def static void main(String[] args) {
		POIBootstrap.run()
		repo = ApplicationContext.instance.getSingleton(typeof(POI)) as RepoPOI
		usuarios = ApplicationContext.instance.getSingleton(typeof(Terminal)) as RepoUsuarios
		XTRest.start(busquedaController, 9000)
	}
	

	@Post("/paginas")
	
	def Result buscarCrit(@Body String listaCriterios) {
		println(listaCriterios)
		println(repo.buscar(listaCriterios))
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
			val resp = usuarios.validarLogin(body.fromJson(Terminal)).toJson
			println(resp)
			ok(resp)
		} catch (Exception ex) {
			notFound('{"error": "'+ex.toString+'"}')
			ok("false")
		}

	}

}
