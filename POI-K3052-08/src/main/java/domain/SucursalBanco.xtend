package domain

import domain.POI
import java.util.ArrayList
import java.util.List
import org.joda.time.DateTime
import domain.CGP.Dias
import java.util.Locale

class SucursalBanco extends POI {

	/**Horarios de apertura del banco */
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura del banco */
	List<Dias> diasAbierto = new ArrayList<Dias>()

	// Constructores
	new() {
		super()
	}

	new(double latitud, double longitud, List<DateTime> horario, List<Dias> diasAbierto) {
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
		val Locale lenguaYPais = new Locale("ES","ar")
		setNombre(nombre)		
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText(lenguaYPais)
		
		if (buscarDia(diasAbierto, Dias.valueOf(nombreDia))) {
			// BANCOS DE LUNES A VIERNES DE 10:00 a 15:00
			evaluarRangoHorario(horario,  dt.getHourOfDay(), dt.getMinuteOfHour())
		}
	}
}
