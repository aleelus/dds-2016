package domain

import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class POI {
	String nombre
	int latitud
	int longitud
	String calle

	def estaCerca(int latitudUser, int longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		val distancia = puntoPOI.distance(puntoUsuario)
		distancia <= 0.5
	}
}
