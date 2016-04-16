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
	 * sus serviscios.*/
	override obtenerDatos() {
		val StringBuilder builder = new StringBuilder()
		builder.append(this.nombre)
		listaServicios.forEach[servicio|builder.append(servicio.nombre + " ")]
		val nombre_servicios = builder.toString()
		return nombre_servicios
	}

	def buscarServicio(String nombre) {	
		
		listaServicios.findFirst[ servicio | servicio.getNombre() == nombre]

	}

	def buscarDiaDelServicio(ServicioCGP servicio, String dia) {
		val List<String> lista = servicio.diasAbierto

		
		if(lista.findFirst[ diaLista | diaLista == dia] !=null)
			return true
		
	}

	// 22           30
	def buscarAlMenosUnServicioDisponible(int hora, int min, String nombreDia) {
		
		 val Iterable<ServicioCGP> servicioEncontrado = listaServicios.filter[servicio | buscarDiaDelServicio(servicio,nombreDia)]
		 
		 if(servicioEncontrado.findFirst[ servicio | evaluarRangoHorario(servicio.getHorario(),hora,min)] !=null)
		 	return true
		
		
	}

	/**Método que comprueba si un CGP está disponible en cierta fecha
	 * para cierto servicio.
	 */
	/*def estaDisponible(String fecha, String nombre) {
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
	}*/
	
	
	def estaDisponible(DateTime dt, String nombre) {
			
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText()
		
		var ServicioCGP servicioEncontrado = new ServicioCGP()
		if (nombre != null) {
			if ((servicioEncontrado = buscarServicio(nombre)) != null) {
				if (buscarDiaDelServicio(servicioEncontrado, nombreDia)) {
					evaluarRangoHorario(servicioEncontrado.getHorario(), dt.getHourOfDay(), dt.getMinuteOfHour())
				}
			}
		} else {
			buscarAlMenosUnServicioDisponible(dt.getHourOfDay(), dt.getMinuteOfHour(), nombreDia)
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
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura */
	List<String> diasAbierto = new ArrayList<String>()

	// Constructores
	new() {
		super()
	}

	new(String servicio, List<DateTime> horario, List<String> diasAbierto) {
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
