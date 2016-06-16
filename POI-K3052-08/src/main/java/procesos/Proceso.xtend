package procesos

interface Proceso {
	def void ejecutarProceso(String nombreUsuario)
	def void agregarProceso(ProcSimple proc)
	def void eliminarProceso(ProcSimple proc)
}