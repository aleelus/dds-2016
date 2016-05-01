package domain

import java.util.List

interface OrigenDatos {
	def List<POI> search(String input)
}