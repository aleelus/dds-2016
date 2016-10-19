package puntosDeInteres

import com.fasterxml.jackson.annotation.JsonIgnore
import java.util.ArrayList
import java.util.List
import java.util.Locale
import javax.persistence.Column
import javax.persistence.ElementCollection
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.OneToMany
import javax.persistence.OneToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.commons.utils.Observable
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon
import puntosDeInteres.POI.Dias

@Accessors
@Observable
@Entity
class CGP extends POI {
	/**
	 * Representa la comuna del CGP.
	 */
	 @OneToOne(fetch=FetchType.LAZY)
	Comuna zona
	
	/**Representa la lista de servicios del CGP. Contiene elementos
	 * de la clase ServicioCGP.
	 */
	 @OneToMany(fetch=FetchType.LAZY)
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()

	new (){
		
	}
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
@Entity
class Comuna {
	
	@Id
    @GeneratedValue
    private Integer id
	/**Polígono que representa el área de la comuna */
	@Transient 
	@JsonIgnore Polygon areaComuna
	@Column(length=150)
	String nombreComuna

	// Constructores
	new (){
		
	}
	
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
@Entity
class ServicioCGP {
	
	@Id
	@GeneratedValue
	private Integer id
	/**Nombre del servicio */
	@Column(length=150)
	String nombre
	/**Horario de apertura */
	@ElementCollection
	List<DateTime> horario = new ArrayList<DateTime>()
	/**Días de apertura */
	@ElementCollection
	List<Dias> diasAbierto = new ArrayList<Dias>()

	// Constructores
	new() {
		
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
