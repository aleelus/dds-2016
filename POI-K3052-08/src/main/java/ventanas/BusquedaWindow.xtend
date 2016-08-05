package ventanas

import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.List

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.tables.Table
import puntosDeInteres.POI
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.Label
import java.awt.Color
import modelosYApp.BusquedaPOIAppModel

class BusquedaWindow extends SimpleWindow<BusquedaPOIAppModel> {
	
	new(WindowOwner parent, BusquedaPOIAppModel model) {
		super(parent, model)
		title = "Busqueda de puntos de interés"
		taskDescription = "Introduzca los criterios deseados y cliquee en Buscar"
		modelObject.completar
	}
	
	override def createMainTemplate(Panel mainPanel) {
		super.createMainTemplate(mainPanel)
		this.crearTablaResultados(mainPanel)
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
		var panelCriterios = new Panel(mainPanel)
		panelCriterios.layout = new ColumnLayout(2)
		new List(panelCriterios) => [
			items <=> "criterios"
		]
		new Button(panelCriterios) =>[
			setCaption("Agregar criterios")
			onClick [ |  ]
			width = 100
		]

	}
	
}