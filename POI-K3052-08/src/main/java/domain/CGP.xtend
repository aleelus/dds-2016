package domain

import java.util.ArrayList
import java.util.Iterator
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon
import org.joda.time.DateTime

@Accessors
class CGP extends POI {
	Comuna comunaPerteneciente
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()

	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		comunaPerteneciente.poseeA(puntoUsuario)
	}

	override obtenerDatos() {
		val nombre_servicios = new String()
		val Iterator<ServicioCGP> iteradorServ = listaServicios.iterator()
		while (iteradorServ.hasNext) {
			nombre_servicios.concat(iteradorServ.next().getNombre())			
			nombre_servicios.concat(" ")
		}
		
		nombre_servicios.concat(nombre)
	}


	new() {
		super()
	}

	new(Comuna comuna) {
		this()
		this.comunaPerteneciente = comuna
	}
	
	def estaDisponible (String fecha, String nombre){		
		
		val DateTime dt = new DateTime(fecha)
		val int anio = dt.getYear()
		val int mes = dt.getMonthOfYear()
		val int dia = dt.getDayOfMonth()
		val int hora = dt.getHourOfDay()
		val int min = dt.getMinuteOfHour()
		val int seg = dt.getSecondOfMinute()
		val DateTime.Property nom = dt.dayOfWeek()		
		val String nombreDia= nom.getAsText()
		
		//println(anio+"/"+mes+"/"+dia+" - "+hora+":"+min+":"+seg)
		
	}
}

@Accessors
class Comuna {
	Polygon areaComuna

	def poseeA(Point punto) {
		areaComuna.isInside(punto)
	}

	new() {
		super()
	}

	new(Point... puntos) {
		this()
		areaComuna = new Polygon(puntos)
	}
}

@Accessors
class ServicioCGP {
	String nombre
	List<String> horario = new ArrayList<String>()
	List<String> diasAbierto = new ArrayList<String>()
	
}



