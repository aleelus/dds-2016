package fabricasProcesos

import procesos.Proceso

interface ProcFactory {
	def Proceso crearProceso()
}