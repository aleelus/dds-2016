package domain

import org.uqbar.geodds.Point

class ParadaColectivo extends POI {

	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		val distancia = puntoPOI.distance(puntoUsuario)
		distancia <= 0.1
	}

}
