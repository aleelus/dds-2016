package domain

import java.util.List

//Interfaz que deben implementar todos los orígenes de datos
interface OrigenDatos<T> {
	def List<POI> search(String input)
	def void create(T punto)
	def void delete(T punto)
}