package puntosDeInteres

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.commons.model.Entity
import org.uqbar.geodds.Point


@Accessors
class POI extends Entity {

	// Campos
	/**Nombre del punto de interés */
	String nombre
	/**Latitud del punto de interés */
	double latitud
	/**Longitud del punto de interés */
	double longitud

	enum Dias {

		lunes,
		martes,
		miercoles,
		jueves,
		viernes,
		sabado,
		domingo
	}

	// Métodos
	/**Método que indica si una punto de interés genérico
	 * está cerca de una latitud y longitud determinados.
	 */
	def estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) / 10 <= 5
	}

	/**Método que verifica si un input está contenido en el nombre del POI */
	def contieneTexto(String input) {
		nombre.contains(input)
	}

	def buscarDia(List<Dias> lista, Dias dia) {
		if (lista.findFirst[diaLista|diaLista == dia] != null)
			return true
	}

	def evaluarRangoHorario(List<DateTime> lista, int horaActual, int minActual) {

		val int[] x = newIntArrayOfSize(lista.size)
		val horario = horaActual * 100 + minActual

		lista.forEach[dt, c|x.set(c, dt.getHourOfDay() * 100 + dt.getMinuteOfHour())]

		for (var i = 0; i < x.size; i++) {
			if (x.get(i) <= horario && horario <= x.get(i + 1)) {
				return true
			} else {
				i++
			}
		}
		false
	}

	def setearDatos(POI poi) {
		nombre = poi.nombre
		latitud = poi.latitud
		longitud = poi.longitud
	}

	override validateCreate() {
		if (nombre.nullOrEmpty) {
			throw new Exception("Por favor introducir un nombre para el Punto de Interés")
		}
		if (this.latitud == 0 && this.longitud == 0) {
			throw new Exception("Por favor introducir una latitud y longitud para el Punto de Interés")
		}
	}

	override equals(Object arg0) {
		val POI puntoAComparar = arg0 as POI
		id.equals(puntoAComparar.id)
	}

	override hashCode() {
		id
	}

}
