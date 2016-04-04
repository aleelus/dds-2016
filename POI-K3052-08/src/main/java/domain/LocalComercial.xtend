package domain

import domain.POI
import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors

class LocalComercial extends POI {
	Rubro rubro

	override estaCerca(int latitudUser, int longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		val distancia = puntoPOI.distance(puntoUsuario)
		distancia <= rubro.radioCercania
	}

}

@Accessors
class Rubro {
	int radioCercania
}
