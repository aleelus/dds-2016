package domain

import java.util.List

//Interfaz que deben implementar todos los orígenes de datos
interface OrigenDatos {
	def List<POI> search(String input)
}