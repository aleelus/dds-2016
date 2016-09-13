package controllers

import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils
import repositorios.RepoUsuarios
import usuario.Terminal

@Controller
class busquedaController {

	extension JSONUtils = new JSONUtils

	def static void main(String[] args) {
		XTRest.start(busquedaController, 9000)
		POIBootstrap.run()
	}

	@Get("/login")
	def usuario(String usuario, String contraseña) {
		try {
			val usuarios = ApplicationContext.instance.getSingleton(typeof(Terminal)) as RepoUsuarios
			response.contentType = ContentType.APPLICATION_JSON
			ok(usuarios.validarLogin(usuario, contraseña).toJson)
		} catch (Exception ex) {
			notFound(ex.toString.toJson)
		}

	}

	def busquedas() {
	}

}
