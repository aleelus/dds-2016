package ventanas

import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.layout.ColumnLayout
import modelosYApp.LoguearUsuarioAppModel
import modelosYApp.BusquedaPOIAppModel

class LoginWindow extends SimpleWindow<LoguearUsuarioAppModel> {
	
	
	new(WindowOwner parent, LoguearUsuarioAppModel model) {
		super(parent, model)
		title = "Bienvenido"
		taskDescription = "Por favor ingrese usuario y contraseña para ingresar al sistema"
	}
	
	override protected addActions(Panel actionsPanel) {
		var buttonsPanel = new Panel(actionsPanel)
		buttonsPanel.layout = new HorizontalLayout
		new Button(buttonsPanel) => [
			caption = "Ingresar"
			onClick[| 
				modelObject.validarLogin
				this.close
				new BusquedaWindow(this, new BusquedaPOIAppModel).open
			]
			width = 100
			disableOnError
			setAsDefault
		]
		
		new Button(buttonsPanel) => [
			caption = "Limpiar"
			onClick[|modelObject.limpiar]
			width = 100
		]
		
		new Button(buttonsPanel) => [
			caption = "Salir"
			onClick[|System.exit(0)]
			width = 100
		]
	}
	
	override protected createFormPanel(Panel mainPanel) {
		val panelLogin = new Panel(mainPanel)
		panelLogin.layout = new ColumnLayout(2)
		new Label(panelLogin).text = "Usuario:"
		new TextBox(panelLogin)=> [
			value <=> "nombreTerminal"
			width = 130
		]
		new Label(panelLogin).text = "Password:"
		new PasswordField(panelLogin)=> [
			value <=> "pass"
			width = 130
		]
	}

		def openDialog(Dialog<?> dialog) {
		dialog.onAccept[ |	this.close ]
		dialog.open
	}		
}