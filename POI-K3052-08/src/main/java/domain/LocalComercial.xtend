package domain

import domain.POI
import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class LocalComercial extends POI {
	Rubro rubro

	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario)/10 <= rubro.radioCercania
	}

	new() {
		super()
	}

	new(Rubro rubro, double latitud, double longitud) {
		this()
		this.rubro = rubro
		this.latitud = latitud
		this.longitud = longitud
	}
}

@Accessors
class Rubro {
	String nombre
	double radioCercania
	new(){
		super()
	}
	new(String nombre,double radio){
		this()
		this.nombre = nombre
		this.radioCercania = radio
	}
}
