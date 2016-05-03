package testsEntrega1

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import domain.SucursalBanco
import java.util.List
import domain.InterfazConsultaBancaria

class StubBusquedaExternaBanco implements InterfazConsultaBancaria{

	// Campos
	List<SucursalBanco> listaSucursales
	String parser

	// Constructores
	new() {
		super()
	}

	new(List<SucursalBanco> listaBancos) {
		this()
		this.listaSucursales = listaBancos
	}

	//Métodos
	/**Método que obtiene las sucursales que cumplen con lo buscado y convierte el resultado a un String JSON */
	override consultar(String input) {
		this.convertirAJSON(listaSucursales.filter[punto|punto.contieneTexto(input)].toList)
	}

	/**Método que convierte una lista de sucursales bancarias a un String JSON*/
	@Deprecated
	def convertirAJSONOld(List<SucursalBanco> lista) {

		parser = "["
		lista.forEach [ banco |

			parser.concat("{\"banco\":")
			parser.concat("\"" + banco.nombre + "\"")
			parser.concat(",\"x\":")
			parser.concat(banco.latitud.toString)
			parser.concat(",\"y\":")
			parser.concat(banco.longitud.toString)
			parser.concat(",\"sucursal\":")
			parser.concat("\"" + banco.nombreSucursal + "\"")
			parser.concat(",\"gerente\":")
			parser.concat("\"" + banco.gerente + "\"")
			parser.concat(",\"servicios\":[")
			banco.servicios.forEach[serv|parser.concat("\"" + serv + "\",")]
			parser.concat("\"\"]")

		]
		parser.concat("]")
		parser

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
}
