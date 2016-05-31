package builders

import puntosDeInteres.ServicioCGP
import java.util.List
import java.util.ArrayList
import puntosDeInteres.CGP
import puntosDeInteres.Comuna
import org.uqbar.geodds.Point
import org.eclipse.xtend.lib.annotations.Accessors
import excepciones.CreationException

@Accessors
class CGPBuilder {
	List<ServicioCGP> servicios = new ArrayList<ServicioCGP>
	String nombre
	double latitud
	double longitud
	Comuna comuna

	def agregarServicios(List<ServicioCGP> listaServicios) {
		servicios.addAll(listaServicios)
		this
	}

	def setNombre(String nombre) {
		if (nombre.empty) {
			throw new CreationException("El nombre no puede ser vacío")
		}
		this.nombre = nombre
		this
	}

	def setLatitud(double latitud) {
		if (latitud.naN) {
			throw new CreationException("La latitud debe ser un número")
		} else {
			this.latitud = latitud
			this
		}
	}

	def setLongitud(double longitud) {
		if (longitud.naN) {
			throw new CreationException("La longitud debe ser un número")
		} else {
			this.longitud = longitud
			this
		}
	}

	def setComuna(Point... puntos) {
		this.comuna = new Comuna(puntos)
		this
	}

	def build() {
		val CGP nuevoCGP = new CGP()
		nuevoCGP.listaServicios = servicios
		nuevoCGP.nombre = nombre
		nuevoCGP.latitud = latitud
		nuevoCGP.longitud = longitud
		nuevoCGP.comunaCGP = comuna
		nuevoCGP
	}
}

class ListaServiciosBuilder{
	List<ServicioCGP> listaServicios= new ArrayList<ServicioCGP>
	
	def crearServicios(String... nombres){
		nombres.forEach[nombre | listaServicios.add(new ServicioCGP(nombre))]
		listaServicios
	}
}