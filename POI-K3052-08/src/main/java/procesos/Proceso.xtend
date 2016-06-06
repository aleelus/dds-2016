package procesos

import repositoriosYAdaptadores.DatosProceso

interface Proceso {
	def DatosProceso ejecutar(String nombreUsuario)
	def void agregarProceso(ProcSimple proc)
	def void eliminarProceso(ProcSimple proc)
}