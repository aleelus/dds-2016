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
	def evaluarRangoHorario(ServicioCGP servicio,int horaActual,int minActual){
		//             Inicio   Fin      Inicio   Fin  (TODO DEL MISMO DIA)
		//EJEMPLO ==>  11:05    16:00    19:00   21:30
		var cont=0			
		val List<String> lista = servicio.horario
		val int[] x = newIntArrayOfSize(lista.size)		
		var DateTime dt
		val horario = horaActual*100+minActual
				
		while(cont<lista.size){		
			
			dt = new DateTime(lista.get(cont))					
			x.set(cont,dt.getHourOfDay()*100+dt.getMinuteOfHour())			
			cont++			
					
		}
				
		for(var i=0 ; i < x.size ;i++){			
			
			if(x.get(i)<=horario && horario<=x.get(i+1)){				
					return true										
			}else{					
				i++
			}			
			
		}
		
		return false
		
		
	}
	
	def buscarAlMenosUnServicioDisponible(int hora, int min, String nombreDia){
		
		var cont=1	
		var ServicioCGP servicioEncontrado = new ServicioCGP()			
			
		while(cont<=listaServicios.size){			
									
			if (buscarDiaDelServicio(listaServicios.get(cont), nombreDia)) {
																					
				if(evaluarRangoHorario(servicioEncontrado, hora, min)){
					return true
				}										
			}
					
			cont++	
		}
		
		return false		
		
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
		var ServicioCGP servicioEncontrado = new ServicioCGP()
		
		if(nombre!=null){			
			if((servicioEncontrado = buscarServicio(nombre)) != null){			
				if (buscarDiaDelServicio(servicioEncontrado, nombreDia)) {	
								
					
												
					evaluarRangoHorario(servicioEncontrado, hora, min)	
									
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



