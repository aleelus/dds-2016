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
import org.uqbar.arena.bindings.NotNullObservable
import java.util.HashMap
import puntosDeInteres.ParadaColectivo
import puntosDeInteres.CGP
import puntosDeInteres.SucursalBanco
import puntosDeInteres.LocalComercial

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
		this.crearColumnas(new Table<POI>(mainPanel,POI) => [
			items <=> "puntosBuscados"
			value <=> "puntoSeleccionado"
			height = 500
			numberVisibleRows = 10
		])
		new NotNullObservable("abonadoSeleccionado")
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
			onClick [ | 
				modelObject.validarCriterios
				modelObject.buscar
			] 
			setAsDefault
			disableOnError	
		]
		new Button(actionsPanel) => [
			setCaption("Limpiar")
			onClick [ | modelObject.limpiar ]	
		]
		
		new Button(actionsPanel) => [
			setCaption("Ver detalles")
			onClick[ | this.abrirDetalles]
		]
	}
	
	def abrirDetalles() {
		val bloqueQueConstruyeVentana = mapaVentanas.get(modelObject.puntoSeleccionado.class)
		bloqueQueConstruyeVentana.apply.open
	}
	
	def getMapaVentanas() {
		return new HashMap<Class<? extends POI>, () => DetallesWindow> => [
			put(typeof(ParadaColectivo), [ | new DetallesParadaWindow(this, modelObject.puntoSeleccionado) ] )
			put(typeof(CGP), [ | new DetallesCGPWindow(this, modelObject.puntoSeleccionado) ] )
			put(typeof(SucursalBanco), [ | new DetallesBancoWindow(this, modelObject.puntoSeleccionado)] )
			put(typeof(LocalComercial), [ | new DetallesLocalComWindow(this, modelObject.puntoSeleccionado)] )
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