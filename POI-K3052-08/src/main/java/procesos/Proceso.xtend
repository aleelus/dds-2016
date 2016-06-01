package procesos

interface Proceso {
	def void ejecutar()
	def void agregarProceso(ProcSimple proc)
	def void eliminarProceso(ProcSimple proc)
}