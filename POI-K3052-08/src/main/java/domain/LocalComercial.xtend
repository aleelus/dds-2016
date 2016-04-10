package domain

import domain.POI
import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors

class LocalComercial extends POI {
	Rubro rubro

	override estaCerca(Point puntoUsuario) {
		val Point puntoPOI = new Point(latitud, longitud)
		val distancia = puntoPOI.distance(puntoUsuario)
		distancia <= rubro.radioCercania
	}

	override obtenerDatos() {
		val nombre_rubro = new String()
		nombre_rubro.concat(rubro.tipo)
		nombre_rubro.concat(" ")
		nombre_rubro.concat(nombre)
	}

}

@Accessors
class Rubro {
	int radioCercania
	String tipo
}
