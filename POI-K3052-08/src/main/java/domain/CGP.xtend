package domain

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon

@Accessors
class CGP extends POI {
	/**
	 * Representa la comuna del CGP.
	 */
	Comuna comunaCGP
	/**Representa la lista de servicios del CGP. Contiene elementos
	 * de la clase ServicioCGP.
	 */
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()

	//Constructores
	new() {
		super()
	}

	new(String nombre, List<ServicioCGP> lista) {
		this()
		this.nombre = nombre
		this.listaServicios = lista
	}

	new(Comuna comuna, List<ServicioCGP> lista) {
		this()
		this.comunaCGP = comuna
		this.listaServicios = lista
	}

	new(Comuna comuna) {
		this()
		this.comunaCGP = comuna
	}

	/**
	 * Método que indica si un CGP está cerca de una latitud y
	 * longitud determinadas.
	 */
	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		comunaCGP.poseeA(puntoUsuario)
	}

	/**Método para obtener el nombre del CGP seguido de todos
	 * sus servicios.*/
	override obtenerDatos() {
		val StringBuilder builder = new StringBuilder()
		builder.append(this.nombre)
		listaServicios.forEach[servicio|builder.append(servicio.nombre + " ")]
		val nombre_servicios = builder.toString()
		return nombre_servicios
	}

	def buscarServicio(String nombre) {
		var cont = 0
		while (cont <= listaServicios.size) {
			if (listaServicios.get(cont).getNombre() == nombre) {
				return listaServicios.get(cont)
			}
			cont++
		}
		return null

	}

	def buscarDiaDelServicio(ServicioCGP servicio, String dia) {
		val List<String> lista = servicio.diasAbierto
		var cont = 0
		while (cont <= lista.size) {
			if (lista.get(cont) == dia) {
				return true
			}
			cont++
		}
		return false
	}

	// 22           30
	def buscarAlMenosUnServicioDisponible(int hora, int min, String nombreDia) {
		var cont = 1
		var ServicioCGP servicioEncontrado = new ServicioCGP()
		while (cont <= listaServicios.size) {
			if (buscarDiaDelServicio(listaServicios.get(cont), nombreDia)) {
				if (evaluarRangoHorario(servicioEncontrado.getHorario(), hora, min)) {
					return true
				}
			}
			cont++
		}
		return false
	}

	/**Método que comprueba si un CGP está disponible en cierta fecha
	 * para cierto servicio.
	 */
	def estaDisponible(String fecha, String nombre) {
		val DateTime dt = new DateTime(fecha)
		val int hora = dt.getHourOfDay()
		val int min = dt.getMinuteOfHour()
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText()
		var ServicioCGP servicioEncontrado = new ServicioCGP()
		if (nombre != null) {
			if ((servicioEncontrado = buscarServicio(nombre)) != null) {
				if (buscarDiaDelServicio(servicioEncontrado, nombreDia)) {
					evaluarRangoHorario(servicioEncontrado.getHorario(), hora, min)
				}
			}
		} else {
			buscarAlMenosUnServicioDisponible(hora, min, nombreDia)
		}
	}
}

@Accessors
class Comuna {
	/**Polígono que representa el área de la comuna */
	Polygon areaComuna

	// Constructores
	new() {
		super()
	}

	new(Point... puntos) {
		this()
		areaComuna = new Polygon(puntos)
	}

	/**Método que devuelve si un punto está dentro del área de la comuna */
	def poseeA(Point punto) {
		areaComuna.isInside(punto)
	}
}

@Accessors
class ServicioCGP {
	/**Nombre del servicio */
	String nombre
	/**Horario de apertura */
	List<String> horario = new ArrayList<String>()
	/**Días de apertura */
	List<String> diasAbierto = new ArrayList<String>()

	// Constructores
	new() {
		super()
	}

	new(String servicio, List<String> horario, List<String> diasAbierto) {
		this()
		this.nombre = servicio
		this.horario = horario
		this.diasAbierto = diasAbierto
	}

	new(String nombre) {
		this()
		this.nombre = nombre
	}

}
