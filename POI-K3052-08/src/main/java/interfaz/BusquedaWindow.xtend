package interfaz

import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.layout.ColumnLayout

class BusquedaWindow extends SimpleWindow<BusquedaPOIAppModel> {
	
	new(WindowOwner parent, BusquedaPOIAppModel model) {
		super(parent, model)
		title = "Busqueda de puntos de interés"
		taskDescription = "Seleccione el criterio de búsqueda"
	}
	
	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) =>[
			setCaption("Agregar criterios")
			onClick [ |  ]
			width = 100
		]
			
		
		new Button(actionsPanel) => [
			setCaption("Buscar")
			onClick [ |  ] 
			setAsDefault
			disableOnError	
		]

		new Button(actionsPanel) => [
			setCaption("Limpiar")
			onClick [ | modelObject.limpiar ]	
		]
		
	}
	
	override protected createFormPanel(Panel mainPanel) {
		var searchFormPanel = new Panel(mainPanel)
		searchFormPanel.layout = new ColumnLayout(2)

	}
	
}