package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import org.joda.time.DateTime
import java.util.List

@Accessors
class POI {
	/**Nombre del punto de interés */
	String nombre
	/**Latitud del punto de interés */
	double latitud
	/**Longitud del punto de interés */
	double longitud
	
	/**Método que indica si una punto de interés genérico
	 * está cerca de una latitud y longitud determinados.
	 */
	def estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) / 10 <= 5
	}
	/**Método que verifica si un input está contenido en el POI */
	def contieneTexto(String input) {
		nombre.contains(input)
	}

	def buscarDia(List<String> lista, String dia) {	
		if(lista.findFirst[ diaLista | diaLista == dia]!=null)
			return true
	}

	def evaluarRangoHorario(List<DateTime> lista, int horaActual, int minActual) {
		
		val int[] x = newIntArrayOfSize(lista.size)		
		val horario = horaActual * 100 + minActual

		lista.forEach[dt , c  | x.set(c,dt.getHourOfDay() * 100 + dt.getMinuteOfHour())] 
					
		for (var i = 0; i < x.size; i++) {
			if (x.get(i) <= horario && horario <= x.get(i + 1)) {
				return true
			} else {
				i++
			}
		}
		return false
	}
}
