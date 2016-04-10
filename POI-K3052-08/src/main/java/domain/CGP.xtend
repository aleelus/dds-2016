package domain

import domain.POI
import org.uqbar.geodds.Polygon
import org.uqbar.geodds.Point
import java.util.List
import java.util.ArrayList
import java.util.Iterator
import org.eclipse.xtend.lib.annotations.Accessors

class CGP extends POI {
	Comuna comunaPerteneciente
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()

	override estaCerca(Point puntoUsuario) {
		comunaPerteneciente.poseeA(puntoUsuario)
	}
	
	override obtenerDatos() {
		val nombre_servicios = new String()
		val Iterator<ServicioCGP> iteradorServ = listaServicios.iterator()
		while (iteradorServ.hasNext){
			nombre_servicios.concat(iteradorServ.next().getNombre())
			nombre_servicios.concat(" ")	
		}
		nombre_servicios.concat(" ")
		nombre_servicios.concat(nombre)
	}

}

@Accessors
class Comuna {
	List<Point> puntos

	def poseeA(Point punto) {
		val Polygon areaComuna = new Polygon(puntos)
		areaComuna.isInside(punto)
	}

}

@Accessors
class ServicioCGP{
	String nombre
}