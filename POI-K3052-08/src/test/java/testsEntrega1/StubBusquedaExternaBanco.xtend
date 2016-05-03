package testsEntrega1

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import domain.SucursalBanco
import java.util.List
import domain.InterfazConsultaBancaria
import java.util.ArrayList

class StubBusquedaExternaBanco implements InterfazConsultaBancaria{

	// Campos
	List<SucursalBanco> listaSucursales

	// Constructores
	new() {
		super()
		this.listaSucursales = new ArrayList<SucursalBanco>()
	}

	new(List<SucursalBanco> listaBancos) {
		this()
		this.listaSucursales = listaBancos
	}

	// Métodos
	/**Método que obtiene las sucursales que cumplen con lo buscado y convierte el resultado a un String JSON */
	override consultar(String input) {
		this.convertirAJSON(listaSucursales.filter[punto|punto.contieneTexto(input)].toList)
	}

	/**Método que convierte una lista de sucursales bancarias a un String JSON*/
	def convertirAJSON(List<SucursalBanco> lista) {
		val JsonArray arraySucursales = Json.array().asArray
		lista.forEach [ sucursal |
			var JsonObject sucursalJSON = Json.object()
			sucursalJSON.add("banco", sucursal.nombre)
			sucursalJSON.add("x", sucursal.longitud)
			sucursalJSON.add("y", sucursal.latitud)
			sucursalJSON.add("sucursal", sucursal.nombreSucursal)
			sucursalJSON.add("gerente", sucursal.gerente)
			sucursalJSON.add("banco", sucursal.nombre)
			var JsonArray arrayServicios = Json.array(sucursal.servicios)
			sucursalJSON.add("servicios", arrayServicios)
			arraySucursales.add(sucursalJSON)
		]
		arraySucursales
	}

	/**Método que agrega una sucursal a la lista de sucursales  */
	override agregarSucursal(SucursalBanco sucursal) {
		listaSucursales.add(sucursal)
	}

	/**Método que elimina una sucursal de la lista de sucursales  */
	override eliminarSucursal(SucursalBanco sucursal) {
		listaSucursales.remove(sucursal)
	}

}
