package puntosDeInteres

import java.util.ArrayList
import java.util.List
import java.util.Locale
import org.joda.time.DateTime
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class SucursalBanco extends POI {

	/**Horarios de apertura del banco */
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura del banco */
	List<Dias> diasAbierto = new ArrayList<Dias>()
	/**Nombre dado a la sucursal */
	String nombreSucursal
	/**Servicios proporcionados por el banco */
	List<String> listaServicios
	/**Nombre del gerente de la sucursal */
	String gerente
	/**Zona del banco */
	Comuna zona

	def estaDisponible(DateTime dt, String nombre) {
		val Locale lenguaYPais = new Locale("ES", "ar")
		setNombre(nombre)
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText(lenguaYPais)

		if (buscarDia(diasAbierto, Dias.valueOf(nombreDia))) {
			// BANCOS DE LUNES A VIERNES DE 10:00 a 15:00
			evaluarRangoHorario(horario, dt.getHourOfDay(), dt.getMinuteOfHour())
		}
	}

}
