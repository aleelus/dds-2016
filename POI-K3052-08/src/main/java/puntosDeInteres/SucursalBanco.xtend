package puntosDeInteres

import java.util.ArrayList
import java.util.List
import java.util.Locale
import javax.persistence.Column
import javax.persistence.ElementCollection
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.OneToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime

@Accessors
@Entity
class SucursalBanco extends POI {

	@Transient
	/**Horarios de apertura del banco */
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura del banco */
	@Transient
	List<Dias> diasAbierto = new ArrayList<Dias>()
	/**Nombre dado a la sucursal */
	@Column(length=150)
	String nombreSucursal
	/**Servicios proporcionados por el banco */
	@ElementCollection 
	List<String> listaServicios
	/**Nombre del gerente de la sucursal */
	@Column(length=150)
	String gerente
	/**Zona del banco */
	@OneToOne(fetch=FetchType.LAZY)
	Comuna zona

	new (){
		
	}
	
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
