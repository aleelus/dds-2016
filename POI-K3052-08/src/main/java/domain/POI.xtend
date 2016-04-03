package domain

import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class POI {
	String nombre
	int latitud
	int longitud
	String calle
	def estaCerca(Point puntoUsuario){
		val Point puntoPOI = new Point(latitud, longitud)
		val distancia = puntoPOI.distance(puntoUsuario)
		return (distancia<=0.5)
	}
}