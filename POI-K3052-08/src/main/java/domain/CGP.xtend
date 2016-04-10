package domain

import java.util.ArrayList
import java.util.Iterator
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import org.uqbar.geodds.Polygon

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
		nombre_servicios.concat(" ")
		nombre_servicios.concat(nombre)
	}

	new() {
		super()
	}

	new(Comuna comuna) {
		this()
		this.comunaPerteneciente = comuna
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
}
