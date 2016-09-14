package controllers

import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils
import repositorios.RepoUsuarios
import usuario.Terminal
import org.uqbar.xtrest.api.annotation.Body

@Controller
class busquedaController {

	extension JSONUtils = new JSONUtils

	def static void main(String[] args) {
		POIBootstrap.run()
		XTRest.start(busquedaController, 9000)
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
