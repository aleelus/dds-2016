package adaptadores

import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonValue
import java.io.BufferedReader
import java.io.FileReader
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import puntosDeInteres.POI
import puntosDeInteres.SucursalBanco

@Accessors
class AdaptadorServicioExterno implements repositorios.OrigenDatos {

	InterfazConsultaBancaria srvExtBanco
	InterfazActLocales srvActLocales
	InterfazREST srvBajaPOI
	
	//Constructores
	new() {
		super()
	}

	new(InterfazConsultaBancaria srvExterno) {
		this.srvExtBanco = srvExterno
	}

	// Métodos
	/**Método que busca en el servicio externo y luego convierte el restultad a una lista de POI's */
	override search(String input) {
		val resultado = srvExtBanco.search(input)
		this.convertirAListaDeSucursalesBancarias(resultado)
	}

	/**Método que convierte un String JSON a una lista de sucursales bancarias */
	def convertirAListaDeSucursalesBancarias(JsonArray resultadoServicioExterno) {

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
	
	def procesarArchivoAct() {
		val archivo = srvActLocales.obtenerArchivo()
		val fr = new FileReader(archivo)
		val br = new BufferedReader(fr)
		var String linea
		val archivoProcesado = new HashMap<String,List<String>>()
		while((linea = br.readLine)!= null){
			var lineaSeparada = linea.split(";", 0)
			var nombreLocal= lineaSeparada.get(0)
			var palabrasClave = lineaSeparada.get(1)
			archivoProcesado.put(nombreLocal,palabrasClave.split(" "))
		}
		br.close
		fr.close
		archivoProcesado
	}
	
	def obtenerPOIAEliminar() {
		val resultado = srvBajaPOI.obtenerArchivoDeBajas()
		val List<String> listaPOI = newArrayList()
		for (JsonValue valor:resultado){
			listaPOI.add(valor.asObject.getString("valor_busqueda",""))
		}
		listaPOI
	}
	
}
