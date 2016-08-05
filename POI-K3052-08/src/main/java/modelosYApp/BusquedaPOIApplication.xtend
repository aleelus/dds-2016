package modelosYApp

import org.uqbar.arena.Application
import ventanas.BusquedaWindow

class BusquedaPOIApplication extends Application {
	
	override protected createMainWindow() {
		//return new LoginWindow(this, new LoguearUsuarioAppModel("banana"))
		 new BusquedaWindow(this, new BusquedaPOIAppModel)
	}
	
	static def void main(String[] args) {
		//Set de datos
		new POIBootstrap().run
		//Aplicación
		new BusquedaPOIApplication().start
		
	}
	
}