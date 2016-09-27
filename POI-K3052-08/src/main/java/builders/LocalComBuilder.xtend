package builders

import puntosDeInteres.Rubro
import puntosDeInteres.LocalComercial
import java.util.List
import org.joda.time.DateTime
import puntosDeInteres.POI.Dias
import excepciones.CreationException

class LocalComBuilder {
	Rubro rubro	
	String nombre
	String direccion
	double latitud
	double longitud
	String[] tags
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
	
	def setDireccion(String direccion){
		this.direccion = direccion
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

	def setRubro(String nombre, int radioCercania){
		this.rubro = new Rubro(nombre,radioCercania)
		this
	}
	def setRubro(String nombre, int radioCercania, List<DateTime> horario, List<Dias> diasAbierto){
		this.rubro = new Rubro(nombre,radioCercania, horario, diasAbierto)
		this
	}
	
	def setTags(String[] tags){
		this.tags = tags
		this
	}
	
	def build(){
		val LocalComercial nuevoLocal = new LocalComercial()
		nuevoLocal.rubro = rubro
		nuevoLocal.nombre = nombre
		nuevoLocal.direccion = direccion
		nuevoLocal.latitud = latitud
		nuevoLocal.longitud = longitud
		nuevoLocal.tags = tags
		nuevoLocal.urlIcono = urlIcono
		nuevoLocal
	}
}