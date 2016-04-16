package domain

import domain.POI
import java.util.ArrayList
import java.util.List
import org.joda.time.DateTime

class SucursalBanco extends POI {

	/**Horarios de apertura del banco */
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura del banco */
	List<String> diasAbierto = new ArrayList<String>()

	// Constructores
	new() {
		super()
	}

	new(double latitud, double longitud, List<DateTime> horario, List<String> diasAbierto) {
		this()
		this.latitud = latitud
		this.longitud = longitud
		this.horario = horario
		this.diasAbierto = diasAbierto
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

	def estaDisponible(DateTime dt, String nombre) {
		setNombre(nombre)		
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText()
		
		if (buscarDia(diasAbierto, nombreDia)) {
			// BANCOS DE LUNES A VIERNES DE 10:00 a 15:00
			evaluarRangoHorario(horario,  dt.getHourOfDay(), dt.getMinuteOfHour())
		}
	}
}
