package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon

@Accessors
class CGP extends POI {
	Comuna comunaPerteneciente

	override estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		comunaPerteneciente.poseeA(puntoUsuario)
	}

	new() {
		super()
	}

	new(Comuna comuna) {
		this()
		this.comunaPerteneciente = comuna
	}
}

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
