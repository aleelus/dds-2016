package builders

import java.util.List
import org.joda.time.DateTime
import puntosDeInteres.POI.Dias
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import puntosDeInteres.SucursalBanco

@Accessors
class BancoBuilder {
	String nombre
	double latitud
	double longitud
	List<DateTime> horario = new ArrayList<DateTime>
	List<Dias> diasAbierto = new ArrayList<Dias>
	String nombreSucursal
	List<String> servicios
	String gerente

	def setNombre(String nombre) {
		this.nombre = nombre
		this
	}

	def setLatitud(double latitud) {
		this.latitud = latitud
		this
	}

	def setLongitud(double longitud) {
		this.longitud = longitud
		this
	}
	
	def setSucursal(String nombre){
		this.nombreSucursal=nombre
		this
	}
	
	def setServicios(List<String> listaServicios){
		this.servicios = listaServicios
		this
	}
	
	def setGerente(String nombre){
		this.gerente=nombre
		this
	}
	
	def setHorarioAbierto(List<DateTime> horariosAbierto){
		this.horario = horariosAbierto
		this
	}
	
	def setDiasAbierto(List<Dias> dias){
		this.diasAbierto = dias
		this
	}
	
	def build(){
		val SucursalBanco banco = new SucursalBanco()
		banco.nombre = nombre
		banco.latitud = latitud
		banco.longitud = longitud
		banco.nombreSucursal = nombreSucursal
		banco.servicios = servicios
		banco.gerente = gerente
		banco.horario = horario
		banco.diasAbierto = diasAbierto
		banco
	}
}
