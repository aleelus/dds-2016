package domain

import org.uqbar.geodds.Point

class ParadaColectivo extends POI {

	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario)/10 <= 1
	}
	new(){
		super()
	}
	new(double latitud, double longitud){
		this()
		this.latitud = latitud
		this.longitud = longitud
	}
	
	def estaDisponible(String fecha, String nombre){
		
		//VER ESTO DESPUES ( NO ME PEGUEN SOY GIORDANO (?) )
		return true
		
	}
}
