package domain

import org.uqbar.geodds.Point
import org.joda.time.DateTime

class ParadaColectivo extends POI {
	
	//Constructores
	new() {
		super()
	}

	new(double latitud, double longitud) {
		this()
		this.latitud = latitud
		this.longitud = longitud
	}

	new(String nombre) {
		this()
		this.nombre = nombre
	}

	/**Método que indica si una Parada está cerca de una latitud y
	 * longitud determinados.
	 */
	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		System.out.println(puntoPOI.distance(puntoUsuario) / 10)
		puntoPOI.distance(puntoUsuario) / 10 <= 1
	}
	
	def estaDisponible(DateTime dt, String nombre) {

		// VER ESTO DESPUES ( NO ME PEGUEN SOY GIORDANO (?) )
		return true

	}
}
