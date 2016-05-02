package domain

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonValue
import java.util.List

class AdaptadorServicioExterno {
	
	String parser

	def convertir(String resultadoServicioExterno) {
	
		var SucursalBanco sucursal
		var JsonArray arrayServicios
		var List<String> listaServicios
		var List<SucursalBanco> listaSucursales
	
		val JsonArray arraySucursales = Json.parse(resultadoServicioExterno).asArray()
		
		
		for (JsonValue valor : arraySucursales) {
			sucursal = new SucursalBanco()
			sucursal.nombre = valor.asObject.getString("banco", "Banco desconocido")
			sucursal.latitud = valor.asObject.getDouble("x", 0)
			sucursal.longitud = valor.asObject.getDouble("y", 0)
			sucursal.nombreSucursal = valor.asObject.getString("sucursal", "Sucursal desconocido")
			sucursal.gerente = valor.asObject.getString("gerente", "Gerente desconocido")
			arrayServicios = valor.asObject.get("servicios").asArray
			for (JsonValue servicio : arraySucursales) {
				listaServicios.add(servicio.asString)
			}
			sucursal.servicios = listaServicios
			listaSucursales.add(sucursal)
		}
		listaSucursales
	}
	
	//Recibe la lista ya filtrada
	def  trabajarLista(List<SucursalBanco> lista){	
				 
		parser = "["		
		lista.forEach[ banco | 
			
			parser.concat("{\"banco\":")
			parser.concat("\""+banco.nombre+"\"")
			parser.concat(",\"x\":")
			parser.concat(banco.latitud.toString)
			parser.concat(",\"y\":")
			parser.concat(banco.longitud.toString)
			parser.concat(",\"sucursal\":")
			parser.concat("\""+banco.nombreSucursal+"\"")
			parser.concat(",\"gerente\":")
			parser.concat("\""+banco.gerente+"\"")
			parser.concat(",\"servicios\":[")
			banco.servicios.forEach[serv | parser.concat("\""+serv+"\",")]
			parser.concat("\"\"]")			
			
		]				
		parser.concat("]")	
		
		parser
		
	}

	
	

}
