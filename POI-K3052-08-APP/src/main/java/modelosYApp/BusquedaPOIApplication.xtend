package modelosYApp

import org.uqbar.arena.Application
import ventanas.LoginWindow

class BusquedaPOIApplication extends Application {
	
	override protected createMainWindow() {
		new LoginWindow(this, new LoguearUsuarioAppModel())
	}
	
	static def void main(String[] args) {
		//Set de datos
		new POIBootstrap().run
		//Aplicación
		new BusquedaPOIApplication().start
		
	}
	
}