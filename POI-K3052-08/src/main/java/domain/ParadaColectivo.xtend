package domain

import org.uqbar.geodds.Point

class ParadaColectivo extends POI {
	
	override estaCerca(Point puntoUsuario) {
		val Point puntoPOI = new Point(latitud, longitud)
		val distancia = puntoPOI.distance(puntoUsuario)
		return (distancia<=0.1)
	}
	
}