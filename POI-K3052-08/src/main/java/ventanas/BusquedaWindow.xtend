package ventanas

import java.awt.Color
import modelosYApp.BusquedaPOIAppModel
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import puntosDeInteres.POI

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.layout.HorizontalLayout

class BusquedaWindow extends SimpleWindow<BusquedaPOIAppModel> {
	
	new(WindowOwner parent, BusquedaPOIAppModel model) {
		super(parent, model)
		title = "Busqueda de puntos de interés"
		taskDescription = "Introduzca los criterios deseados y cliquee en Buscar"
		modelObject.completar
	}
	
	override def createMainTemplate(Panel mainPanel) {
		super.createErrorsPanel(mainPanel);
		this.createFormPanel(mainPanel);
		this.crearTablaResultados(mainPanel)
		super.createActionsPanel(mainPanel);
		
	}
	
	def crearTablaResultados(Panel mainPanel) {
		new Label(mainPanel) => [
			text = "Resultado de la búsqueda"
			fontSize = 16
			foreground = Color.BLACK
		]
		this.crearColumnas(new Table(mainPanel,POI) => [
			items <=> "puntosBuscados"
			value <=> "puntoSeleccionado"
			height = 500
			numberVisibleRows = 10
		])
	}
	
	def crearColumnas(Table<POI> tabla) {
		new Column<POI>(tabla) => [
			title = "Nombre"
			fixedSize = 100
			bindContentsToProperty("nombre")
		]
		
		new Column<POI>(tabla) => [
			title = "Dirección"
			fixedSize = 200
			bindContentsToProperty("direccion")
		]
	}
	
	override protected addActions(Panel actionsPanel) {
		actionsPanel.layout = new HorizontalLayout
		new Button(actionsPanel) => [
			setCaption("Buscar")
			onClick [ | modelObject.validarCriterios ] 
			setAsDefault
			disableOnError	
		]
		new Button(actionsPanel) => [
			setCaption("Limpiar")
			onClick [ | modelObject.limpiar ]	
		]
	}
	
	override protected createFormPanel(Panel mainPanel) {
		new Label(mainPanel) => [
			text = "Criterios de búsqueda"
			fontSize = 16
			foreground = Color.BLACK
			
		]
		var panelCriterios = new Panel(mainPanel).layout = new ColumnLayout(2)
		var panelIzqCriterios = new Panel(panelCriterios)
		new Label(panelIzqCriterios) =>[
			text = "Nombres a buscar:"
		]
		new List(panelIzqCriterios) => [
			items <=> "criterios"
			value <=> "criterioSeleccionado"
			width = 100
			height = 100
		]
		val panelBotonesCriterios = new Panel(panelCriterios)
		new Button(panelBotonesCriterios) =>[
			setCaption("Agregar criterios")
			onClick [ |  
				new AgregarCriterioWindow(this, this.modelObject).open
				]
		]
		
		new Button(panelBotonesCriterios) =>[
			setCaption("Eliminar criterio")
			onClick [ |  
				modelObject.eliminarCriterio()
				]
		]

	}
	
}