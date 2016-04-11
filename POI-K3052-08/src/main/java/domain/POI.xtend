package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import org.joda.time.DateTime
import java.util.List

@Accessors
class POI {
	String nombre
	double latitud
	double longitud
	String calle

	def estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) /10 <= 5
	}

	def obtenerDatos() {
		this.getNombre()
	}
	
	def buscarDia(List<String> lista,String dia){
					
		var cont=0
		while(cont<=lista.size){
			
			if(lista.get(cont) == dia){
				return true
			}	
			cont++
		}
		return false
		
		
	}
	
	
	def evaluarRangoHorario(List<String> lista,int horaActual,int minActual){

		var cont=0			
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
	

	
	
}
