package domain

import domain.POI
import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import org.joda.time.DateTime
import domain.POI.Dias

@Accessors
class LocalComercial extends POI {
	/**Representa el tipo de local */
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

	/**Método que indica si un Local está cerca de una latitud y
	 * longitud determinados.
	 */
	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) / 10 <= rubro.radioCercania
	}
	
	/**Método que retorna si el String está en el nombre o en el rubro */
	override contieneTexto(String input) {
		nombre.contains(input) || rubro.contiene(input)
	}

	def estaDisponible(DateTime dt, String nombre) {
		setNombre(nombre)	 
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText()
		
		if (buscarDia(rubro.diasAbierto, Dias.valueOf(nombreDia))) {
			evaluarRangoHorario(rubro.horario, dt.getHourOfDay(), dt.getMinuteOfHour())
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
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Determina los días de apertura del rubro */
	List<Dias> diasAbierto = new ArrayList<Dias>()

	//Constructores
	new() {
		super()
	}

	new(String nombre, double radio, List<DateTime> horario, List<Dias> diasAbierto) {
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
	
	def contiene(String input) {
		nombre.contains(input)
	}
	
}
