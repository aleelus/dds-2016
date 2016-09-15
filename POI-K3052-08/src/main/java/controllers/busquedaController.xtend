package controllers

import org.eclipse.xtend.lib.annotations.Accessors
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
	


	def static void main(String[] args) {
		POIBootstrap.run()
		XTRest.start(busquedaController, 9000)
		repo = ApplicationContext.instance.getSingleton(typeof(POI)) as RepoPOI
	}
	
	@Post("/paginas")
	def Result buscarCrit(@Body String listaCriterios) {
		println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		
		println(listaCriterios)
		

		response.contentType = ContentType.APPLICATION_JSON
		ok(repo.buscar(listaCriterios).toJson)

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
