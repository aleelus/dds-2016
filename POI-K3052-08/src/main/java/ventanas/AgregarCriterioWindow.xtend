package ventanas

import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel
import modelosYApp.BusquedaPOIAppModel
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.TextBox

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.layout.HorizontalLayout

class AgregarCriterioWindow extends Dialog<BusquedaPOIAppModel> {
	
	new(WindowOwner owner, BusquedaPOIAppModel model) {
		super(owner, model)
		title = "Introduzca un nuevo criterio"
		taskDescription = "Una vez escrito el nuevo criterio seleccione Aceptar"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		val panelLogin = new Panel(mainPanel)
		panelLogin.layout = new ColumnLayout(2)
		new Label(panelLogin).text = "Nuevo criterio:"
		new TextBox(panelLogin)=> [
			value <=> "criterioNuevo"
			width = 100
		]
	}
	
	override protected addActions(Panel actionsPanel) {
		actionsPanel.layout = new HorizontalLayout()
		new Button(actionsPanel)
			.setCaption("Aceptar")
			.onClick [ | this.accept ]
			.setAsDefault
			.disableOnError

		new Button(actionsPanel)
			.setCaption("Cancelar")
			.onClick[|this.cancel]
	}
	
	override accept() {
		modelObject.agregarCriterio()
		super.accept()
	}
	
}