package procesos

import repositoriosYAdaptadores.RepoPOI
import builders.LocalComBuilder

class ProcActualizacionLocal extends ProcSimple {
	RepoPOI repositorio
	String archivo

	override ejecutar() {
		val nombreLocal = archivo.split(";", 0).get(0)
		val palabrasClave = archivo.split(";", 0).get(1)
		val palabrasClaveSeparadas = palabrasClave.split(" ")
		val pois = repositorio.search(nombreLocal)
		if (pois.isEmpty) {
			val builderLocal = new LocalComBuilder()
			builderLocal => [
				setNombre(nombreLocal)
				setTags(palabrasClaveSeparadas)
			]
			repositorio.create(builderLocal.build())
		} else {
			pois.forEach[poi|poi.tags.addAll(palabrasClaveSeparadas)]
		}
	}
}
