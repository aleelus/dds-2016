package procesos

import procesos.Proceso
import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProcCompuesto implements Proceso {
	
	List<ProcSimple> procesosSimples = new ArrayList<ProcSimple>
	
	override agregarProceso(ProcSimple proc) {
		procesosSimples.add(proc)
	}
	
	override eliminarProceso(ProcSimple proc) {
		procesosSimples.remove(proc)
	}
	
	override ejecutarProceso(String nombreUsuario) {
		procesosSimples.forEach[proceso | proceso.ejecutarProceso(nombreUsuario)]
	}
	
	def sinProcesos() {
		procesosSimples.size==0
	}
	
}