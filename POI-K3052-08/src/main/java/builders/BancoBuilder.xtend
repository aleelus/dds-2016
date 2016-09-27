package builders

import java.util.List
import org.joda.time.DateTime
import puntosDeInteres.POI.Dias
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import puntosDeInteres.SucursalBanco
import excepciones.CreationException
import puntosDeInteres.Comuna

@Accessors
class BancoBuilder {
	String nombre
	double latitud
	double longitud
	String direccion
	Comuna zona
	List<String> tags = new ArrayList<String>
	List<DateTime> horario = new ArrayList<DateTime>
	List<Dias> diasAbierto = new ArrayList<Dias>
	String nombreSucursal
	List<String> listaServicios
	String gerente
	String urlIcono

	def setUrlIcono(String url){
		this.urlIcono = url
	}

	def setNombre(String nombre) {
		if (nombre.empty) {
			throw new CreationException("El nombre no puede ser vacío")
		}
		this.nombre = nombre
		this
	}

	def setLatitud(double latitud) {
		if (latitud.naN) {
			throw new CreationException("La latitud debe ser un número")
		} else {
			this.latitud = latitud
			this
		}
	}

	def setLongitud(double longitud) {
		if (longitud.naN) {
			throw new CreationException("La longitud debe ser un número")
		} else {
			this.longitud = longitud
			this
		}
	}
	
	def setZona(Comuna comuna){
		this.zona = comuna
		this
	}
	
	def setDireccion(String direccion){
		this.direccion = direccion
		this
	}
	
	def setSucursal(String nombre){
		this.nombreSucursal=nombre
		this
	}
	
	def setTags(List<String> listaTags){
		this.tags = listaTags
		this
	}
	
	def setServicios(List<String> listaServicios){
		this.listaServicios = listaServicios
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
		banco.direccion = direccion
		banco.latitud = latitud
		banco.longitud = longitud
		banco.nombreSucursal = nombreSucursal
		banco.listaServicios = listaServicios
		banco.gerente = gerente
		banco.horario = horario
		banco.diasAbierto = diasAbierto
		banco.zona = zona
		banco.urlIcono = urlIcono
		banco
	}
}
