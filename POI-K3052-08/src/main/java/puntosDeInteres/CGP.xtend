package puntosDeInteres

import java.util.ArrayList
import java.util.List
import java.util.Locale
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon
import puntosDeInteres.POI.Dias
import org.uqbar.commons.utils.Observable
import com.fasterxml.jackson.annotation.JsonIgnore

@Accessors
@Observable
class CGP extends POI {
	/**
	 * Representa la comuna del CGP.
	 */
	Comuna zona
	
	/**Representa la lista de servicios del CGP. Contiene elementos
	 * de la clase ServicioCGP.
	 */
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()

	/**
	 * Método que indica si un CGP está cerca de una latitud y
	 * longitud determinadas.
	 */
	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		zona.poseeA(puntoUsuario)
	}

	/**Método que devuelve si un texto está presente en el nombre o en el nombre de los servicios.*/
	override contieneTexto(String input) {
		(nombre.contains(input) || listaServicios.exists[servicio | servicio.contiene(input)] || super.contieneTextoEnTags(input)) && this.estaHabilitado
	}

	def buscarServicio(String nombre) {	
		
		listaServicios.findFirst[ servicio | servicio.getNombre() == nombre]

	}

	def buscarDiaDelServicio(ServicioCGP servicio, Dias dia) {
		val List<Dias> lista = servicio.diasAbierto

		
		if(lista.findFirst[ diaLista | diaLista == dia] !=null)
			return true
		
	}

	// 22           30
	def buscarAlMenosUnServicioDisponible(int hora, int min, Dias nombreDia) {
		
		 val Iterable<ServicioCGP> servicioEncontrado = listaServicios.filter[servicio | buscarDiaDelServicio(servicio,nombreDia)]
		 
		 if(servicioEncontrado.findFirst[ servicio | evaluarRangoHorario(servicio.getHorario(),hora,min)] !=null)
		 	return true
		
		
	}

	/**Método que comprueba si un CGP está disponible en cierta fecha
	 * para cierto servicio.
	 */	
	def estaDisponible(DateTime dt, String nombre) {
		
		val Locale lenguaYPais = new Locale("ES","ar")	
		val DateTime.Property nom = dt.dayOfWeek()
		val String nombreDia = nom.getAsText(lenguaYPais)
		
		
		
		var ServicioCGP servicioEncontrado = new ServicioCGP()
		if (nombre != null) {
			if ((servicioEncontrado = buscarServicio(nombre)) != null) {			
				
				if (buscarDiaDelServicio(servicioEncontrado, Dias.valueOf(nombreDia))) {
					evaluarRangoHorario(servicioEncontrado.getHorario(), dt.getHourOfDay(), dt.getMinuteOfHour())
				}
			}
		} else {
			buscarAlMenosUnServicioDisponible(dt.getHourOfDay(), dt.getMinuteOfHour(), Dias.valueOf(nombreDia))
		}
	}
	
}

@Accessors
@Observable
class Comuna {
	/**Polígono que representa el área de la comuna */
	@JsonIgnore Polygon areaComuna
	String nombreComuna

	// Constructores

	new(String nombre,Point... puntos) {
		super()
		nombreComuna = nombre
		areaComuna = new Polygon(puntos)
	}

	/**Método que devuelve si un punto está dentro del área de la comuna */
	def poseeA(Point punto) {
		areaComuna.isInside(punto)
	}
}

@Accessors
@Observable
class ServicioCGP {
	/**Nombre del servicio */
	String nombre
	/**Horario de apertura */
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura */
	List<Dias> diasAbierto = new ArrayList<Dias>()

	// Constructores
	new() {
		super()
	}

	new(String servicio, List<DateTime> horario, List<Dias> diasAbierto) {
		this()
		this.nombre = servicio
		this.horario = horario
		this.diasAbierto = diasAbierto
	}

	new(String nombre) {
		this()
		this.nombre = nombre
	}
	
	def contiene(String input){
		nombre.contains(input)
	}
}
