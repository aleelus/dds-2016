package controllers

import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.json.JSONUtils

@Controller
class busquedaController {
	
	
	extension JSONUtils = new JSONUtils

	def static void main(String[] args) {
		XTRest.start(busquedaController, 9000)
		POIBootstrap.run()
	}

	def busquedas() {
		
		
	
		
	}
	
}