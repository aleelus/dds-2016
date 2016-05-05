package repositoriosYAdaptadores

import java.util.List
import puntosDeInteres.POI

//Interfaz que deben implementar todos los orígenes de datos
interface OrigenDatos<T> {
	def List<POI> search(String input)
}