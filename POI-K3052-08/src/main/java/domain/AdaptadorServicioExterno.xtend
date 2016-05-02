package domain

import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonValue
import java.util.List
import testsEntrega1.StubBusquedaExternaBanco
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

@Accessors
class AdaptadorServicioExterno implements OrigenDatos<SucursalBanco> {

	StubBusquedaExternaBanco srvExtBanco
	
	//Constructores
	new() {
		super()
	}

	new(StubBusquedaExternaBanco srvExterno) {
		this.srvExtBanco = srvExterno
	}
	
	//Métodos
	/**Método que busca en el servicio externo y luego convierte el restultad a una lista de POI's */
	override search(String input) {
		val JsonArray resultado = srvExtBanco.consultar(input)
		this.convertirALista(resultado)
	}
	
	/**Método que agrega una sucursal al servicio externo */
	override create(SucursalBanco sucursal) {
		sucursal.validateCreate()
		srvExtBanco.agregarSucursal(sucursal)
	}

	/**Método que convierte un String JSON a una lista de sucursales bancarias */
	def convertirALista(JsonArray resultadoServicioExterno) {

		var SucursalBanco sucursal
		var JsonArray arrayServicios
		var List<String> listaServicios = new ArrayList<String>()
		var List<POI> listaSucursales = new ArrayList<POI>()

		for (JsonValue valor : resultadoServicioExterno) {
			sucursal = new SucursalBanco()
			sucursal.nombre = valor.asObject.getString("banco", "Banco desconocido")
			sucursal.latitud = valor.asObject.getDouble("x", 0)
			sucursal.longitud = valor.asObject.getDouble("y", 0)
			sucursal.nombreSucursal = valor.asObject.getString("sucursal", "Sucursal desconocido")
			sucursal.gerente = valor.asObject.getString("gerente", "Gerente desconocido")
			arrayServicios = valor.asObject.get("servicios").asArray
			for (JsonValue servicio : arrayServicios) {
				listaServicios.add(servicio.toString)
			}
			sucursal.servicios = listaServicios
			listaSucursales.add(sucursal)
		}
		listaSucursales
	}
	
	override delete(SucursalBanco sucursal) {
		sucursal.validateDelete()
		srvExtBanco.eliminarSucursal(sucursal)
	}

}
