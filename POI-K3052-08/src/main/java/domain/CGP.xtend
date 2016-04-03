package domain

import domain.POI
import org.uqbar.geodds.Polygon
import org.uqbar.geodds.Point
import java.util.List

class CGP extends POI {
	Comuna comunaPerteneciente

	override estaCerca(Point puntoUsuario) {
		comunaPerteneciente.poseeA(puntoUsuario)
	}

}

class Comuna {
	List<Point> puntos

	def poseeA(Point punto) {
		val Polygon areaComuna = new Polygon(puntos)
		areaComuna.isInside(punto)
	}

}
