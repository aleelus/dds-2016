package procesos

interface Proceso {
	def void ejecutar(String nombreUsuario)
	def void agregarProceso(ProcSimple proc)
	def void eliminarProceso(ProcSimple proc)
}