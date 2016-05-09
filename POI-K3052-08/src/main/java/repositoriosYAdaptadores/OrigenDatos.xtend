package repositoriosYAdaptadores

import java.util.List
import puntosDeInteres.POI

//Interfaz que deben implementar todos los orígenes de datos
interface OrigenDatos {
	def List<POI> search(String input)
}