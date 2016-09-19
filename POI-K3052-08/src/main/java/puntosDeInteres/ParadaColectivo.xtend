package puntosDeInteres

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.geodds.Point

@Accessors
class ParadaColectivo extends POI {
	
	List<String> lineas =  new ArrayList<String>
	
	//Constructores
	new() {
		super()
	}

	new(String nombre, double latitud, double longitud, String direccion, List<String> lineasCol) {
		this()
		this.nombre = nombre
		this.latitud = latitud
		this.longitud = longitud
		this.direccion = direccion
		this.lineas = lineasCol
	}

	/**Método que indica si una Parada está cerca de una latitud y
	 * longitud determinados.
	 */
	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) / 10 <= 1
	}
	
	def estaDisponible(DateTime dt, String nombre) {

		true

	}
}
