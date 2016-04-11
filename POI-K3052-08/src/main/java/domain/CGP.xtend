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

	new(Comuna comuna,List<ServicioCGP> lista) {
		this()
		this.comunaPerteneciente = comuna
		this.listaServicios = lista
	}
	
	new(Comuna comuna) {
		this()
		this.comunaPerteneciente = comuna		
	}
	
	
		
	def buscarServicio(String nombre){
		
		var cont=0
		while(cont<=listaServicios.size){
						
			if(listaServicios.get(cont).getNombre() == nombre){
				
				return listaServicios.get(cont)
			}	
			cont++
		}
		return null
				
	}
		
	def buscarDiaDelServicio(ServicioCGP servicio,String dia){
		
		val List<String> lista = servicio.diasAbierto
		var cont=0
		while(cont<=lista.size){
			
			if(lista.get(cont) == dia){
				return true
			}	
			cont++
		}
		return false
	}
														//     22           30

	
	def buscarAlMenosUnServicioDisponible(int hora, int min, String nombreDia){
		
		var cont=1	
		var ServicioCGP servicioEncontrado = new ServicioCGP()			
			
		while(cont<=listaServicios.size){			
									
			if (buscarDiaDelServicio(listaServicios.get(cont), nombreDia)) {
																					
				if(evaluarRangoHorario(servicioEncontrado.getHorario(), hora, min)){
					return true
				}										
			}
					
			cont++	
		}
		
		return false		
		
	}
	def estaDisponible (String fecha, String nombre){		
		
		val DateTime dt = new DateTime(fecha)

		val int hora = dt.getHourOfDay()
		val int min = dt.getMinuteOfHour()

		val DateTime.Property nom = dt.dayOfWeek()		
		val String nombreDia= nom.getAsText()		
		var ServicioCGP servicioEncontrado = new ServicioCGP()
		
		if(nombre!=null){			
			if((servicioEncontrado = buscarServicio(nombre)) != null){			
				if (buscarDiaDelServicio(servicioEncontrado, nombreDia)) {	
								
					
												
					evaluarRangoHorario(servicioEncontrado.getHorario(), hora, min)	
									
				}
			
			}			
		}else{
			buscarAlMenosUnServicioDisponible(hora,min,nombreDia)			
			
		}
		
		
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
	
	
	new() {
		super()
	}

	new(String servicio, List<String> horario, List<String> diasAbierto) {
		this()
		this.nombre = servicio
		this.horario = horario
		this.diasAbierto = diasAbierto
	}
	
	
}



