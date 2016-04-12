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
	/**Método que devuelve los datos de un punto de interés genérico */
	def obtenerDatos() {
		this.getNombre()
	}

	def buscarDia(List<String> lista, String dia) {
		var cont = 0
		while (cont <= lista.size) {
			if (lista.get(cont) == dia) {
				return true
			}
			cont++
		}
		return false
	}

	def evaluarRangoHorario(List<String> lista, int horaActual, int minActual) {
		var cont = 0
		val int[] x = newIntArrayOfSize(lista.size)
		var DateTime dt
		val horario = horaActual * 100 + minActual
		while (cont < lista.size) {
			dt = new DateTime(lista.get(cont))
			x.set(cont, dt.getHourOfDay() * 100 + dt.getMinuteOfHour())
			cont++
		}
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
