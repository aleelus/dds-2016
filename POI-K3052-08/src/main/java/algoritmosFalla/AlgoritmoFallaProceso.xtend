package algoritmosFalla

import procesos.Proceso

interface AlgoritmoFallaProceso {
	def void procesarFalla(String terminal, Proceso proceso)
}