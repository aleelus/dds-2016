package domain

import domain.POI
import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import org.joda.time.DateTime

@Accessors
class LocalComercial extends POI {
	/**Rubro del local */
	Rubro rubro

	// Constructores
	new() {
		super()
	}

	new(Rubro rubro, double latitud, double longitud) {
		this()
		this.rubro = rubro
		this.latitud = latitud
		this.longitud = longitud
	}

	new(Rubro rubro, String nombre) {
		this()
		this.rubro = rubro
		this.nombre = nombre
	}

	/**Método que indica si un CGP está cerca de una latitud y
	 * longitud determinados.
	 */
	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) / 10 <= rubro.radioCercania
	}
	
	/**Método que obtiene el rubro seguido del nombre */
	override obtenerDatos() {
		val nombre_rubro = new String(rubro.nombre)
		nombre_rubro.concat(" "+nombre)
	}

	def estaDisponible(String fecha, String nombre) {
		setNombre(nombre)
		val DateTime dt = new DateTime(fecha)
		val int hora = dt.getHourOfDay()
		val int min = dt.getMinuteOfHour()
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText()
		if (buscarDia(rubro.diasAbierto, nombreDia)) {
			evaluarRangoHorario(rubro.horario, hora, min)
		}
	}
}

@Accessors
class Rubro {
	
	/**Determina el radío máximo a partir del cual un
	 * LocalComercial está lejos
	 */
	double radioCercania
	/**Determina el nombre del rubro */
	String nombre
	/**Determina el horario del rubro */
	List<String> horario = new ArrayList<String>()
	/**Determina los días de apertura del rubro */
	List<String> diasAbierto = new ArrayList<String>()

	//Constructores
	new() {
		super()
	}

	new(String nombre, double radio, List<String> horario, List<String> diasAbierto) {
		this()
		this.nombre = nombre
		this.radioCercania = radio
		this.horario = horario
		this.diasAbierto = diasAbierto
	}

	new(String nombre, double radio) {
		this()
		this.nombre = nombre
		this.radioCercania = radio
	}
}
