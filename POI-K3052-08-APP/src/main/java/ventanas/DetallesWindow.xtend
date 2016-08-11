package ventanas

import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import puntosDeInteres.POI

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.List
import org.uqbar.arena.bindings.ObservableProperty
import org.uqbar.arena.bindings.PropertyAdapter
import puntosDeInteres.ServicioCGP
import org.eclipse.xtend.lib.annotations.Accessors

abstract class DetallesWindow extends Dialog<POI> {
	
	new(WindowOwner owner, POI model) {
		super(owner, model)
		this.onAccept[|this.close]
	}
	
	
	override protected createActionsPanel(Panel mainPanel) {
		super.createActionsPanel(mainPanel)
		new Button(mainPanel) => [
			caption = "OK"
			onClick[|this.accept]
		]
	}
	
}

class DetallesParadaWindow extends DetallesWindow{
	
	new(WindowOwner owner, POI model) {
		super(owner, model)
		this.title = "Detalles de parada de colectivo"
		this.taskDescription = "Los detalles de la parada son los siguientes:"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		val panelDetalles = new Panel(mainPanel)
		panelDetalles.layout = new ColumnLayout(2)
		new Label(panelDetalles).text = "Parada de la línea:"
		new Label(panelDetalles) => [
			value <=> "nombre"
		] 
	}
}
@Accessors
abstract class DetallesConDireccionWindow extends DetallesWindow{
	
	Panel panelDetalles
	
	new(WindowOwner owner, POI model) {
		super(owner, model)
	}
	
	override protected createFormPanel(Panel mainPanel) {
		panelDetalles = new Panel(mainPanel)
		panelDetalles.layout = new ColumnLayout(2)
		new Label(panelDetalles).text = "Dirección:"
		new Label(panelDetalles) => [
			value <=> "direccion"
		] 
	}
	
}

class DetallesCGPWindow extends DetallesConDireccionWindow{
	
	new(WindowOwner owner, POI model) {
		super(owner, model)
		this.title = "Detalles de CGP"
		this.taskDescription = "Los detalles del CGP son los siguientes:"
	}
	
	override protected createMainTemplate(Panel mainPanel) {
		super.createErrorsPanel(mainPanel)
		this.createFormPanel(mainPanel)
		this.crearLista(mainPanel)
		super.createActionsPanel(mainPanel)
	}
	
	override protected createFormPanel(Panel mainPanel) {
		super.createFormPanel(mainPanel)
		new Label(panelDetalles).text = "Zona:"
		new Label(panelDetalles) => [
			value <=> "zona.nombreComuna"
		]
	}
	
	def crearLista(Panel mainPanel){
		new Label(panelDetalles).text = "Servicios:"
		new List(panelDetalles) => [
			items <=> "listaServicios"
			bindItems(new ObservableProperty(this.modelObject, "listaServicios")).adapter = new PropertyAdapter(typeof(ServicioCGP), "nombre")
		] 
	}
}

class DetallesBancoWindow extends DetallesCGPWindow{
	
	new(WindowOwner owner, POI model) {
		super(owner, model)
		this.title = "Detalles de sucursal bancaria"
		this.taskDescription = "Los detalles de la sucursal bancaria son los siguientes:"
	}
	
	override crearLista(Panel mainPanel) {
		new Label(panelDetalles).text = "Servicios:"
		new List(panelDetalles) => [
			items <=> "servicios"
		] 
	}
	
}

class DetallesLocalComWindow extends DetallesConDireccionWindow{
	
	new(WindowOwner owner, POI model) {
		super(owner, model)
		this.title = "Detalles de local comercial"
		this.taskDescription = "Los detalles del local comercial son los siguientes:"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		super.createFormPanel(mainPanel)
		new Label(panelDetalles).text = "Nombre comercial:"
		new Label(panelDetalles) => [
			value <=> "nombre"
		]
		new Label(panelDetalles).text = "Rubro:"
		new Label(panelDetalles) => [
			value <=> "rubro.nombre"
		] 
	}
}