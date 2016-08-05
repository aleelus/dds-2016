package interfaz

import org.uqbar.arena.Application

class BusquedaPOIApplication extends Application {
	
	override protected createMainWindow() {
		return new LoginWindow(this, new LoguearUsuarioAppModel("banana"))
	}
	
	static def void main(String[] args) { 
		new BusquedaPOIApplication().start()
	}
	
}