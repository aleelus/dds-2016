package procesos

import java.util.Map
import java.util.HashMap
import fabricasProcesos.ProcFactory

class EjecutorProcesos {
	Map<Integer, ProcFactory> dictProcesos = new HashMap<Integer, ProcFactory>

	def ejecutarProceso(int i) {
		val proceso = dictProcesos.get(i).crearProceso
		proceso.ejecutar()
	}

}
