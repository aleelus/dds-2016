package puntosDeInteres

import java.util.ArrayList
import java.util.List
import java.util.Locale
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.OneToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.commons.utils.Observable
import org.uqbar.geodds.Point
import puntosDeInteres.POI.Dias

@Accessors
@Entity
class LocalComercial extends POI {
	/**Representa el tipo de local */
	 @OneToOne(fetch=FetchType.LAZY)
	Rubro rubro

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
		(nombre.contains(input) || rubro.contiene(input) || super.contieneTextoEnTags(input)) && this.estaHabilitado
	}

	def estaDisponible(DateTime dt, String nombre) {
		setNombre(nombre)
		val Locale lenguaYPais = new Locale("ES","ar")	 
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText(lenguaYPais)
		
		if (buscarDia(rubro.diasAbierto, Dias.valueOf(nombreDia))) {
			evaluarRangoHorario(rubro.horario, dt.getHourOfDay(), dt.getMinuteOfHour())
		}
	}
}

@Accessors
@Observable
@Entity
class Rubro {
	@Id
    @GeneratedValue
    private Integer id
	/**Determina el radío máximo a partir del cual un
	 * LocalComercial está lejos
	 */
	 @Column
	double radioCercania
	/**Determina el nombre del rubro */
	 @Column
	String nombre
	/**Determina el horario del rubro */
	@Transient 
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Determina los días de apertura del rubro */
	@Transient 
	List<Dias> diasAbierto = new ArrayList<Dias>()

	//Constructores
	new() {
		
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
