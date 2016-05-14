package interfazUsuario

import java.util.HashMap
import java.util.List
import java.util.Map

class ReportePorTerminal implements ObserverBusqueda {
	static Map<String, List<Integer>> elementos = new HashMap<String, List<Integer>>

	override update(DatosBusqueda datos) {
		if (elementos.putIfAbsent(datos.nombreTerminal, newArrayList(datos.cantidadResultados)) != null) {
			elementos.get(datos.nombreTerminal).add(datos.cantidadResultados)
		}
	}

	def static obtenerDatosPorTerminal() {
		val elementosTotales = new HashMap<String, Integer>
		elementos.forEach[usuario,listaResultados| obtenerTotal(usuario, listaResultados, elementosTotales)]
		elementos
	}
	
	def static obtenerTotal(String usuario, List<Integer> listaResultados, HashMap<String, Integer> listaElementos) {
		var int total=0
		for (int cantidad:listaResultados){
			total+=cantidad
		}
		listaElementos.put(usuario, total)
	}

}
