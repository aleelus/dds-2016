package builders

import puntosDeInteres.Rubro
import puntosDeInteres.LocalComercial
import java.util.List
import org.joda.time.DateTime
import puntosDeInteres.POI.Dias

class LocalComBuilder {
	Rubro rubro	
	String nombre
	double latitud
	double longitud
	
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

	def setRubro(String nombre, int radioCercania){
		this.rubro = new Rubro(nombre,radioCercania)
		this
	}
	def setRubro(String nombre, int radioCercania, List<DateTime> horario, List<Dias> diasAbierto){
		this.rubro = new Rubro(nombre,radioCercania, horario, diasAbierto)
		this
	}
	
	def build(){
		val LocalComercial nuevoLocal = new LocalComercial()
		nuevoLocal.rubro = rubro
		nuevoLocal.nombre = nombre
		nuevoLocal.latitud = latitud
		nuevoLocal.longitud = longitud
		nuevoLocal
	}
}