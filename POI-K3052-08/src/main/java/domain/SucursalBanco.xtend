package domain

import domain.POI

class SucursalBanco extends POI {
	new() {
		super()
	}

	new(double latitud, double longitud) {
		this()
		this.latitud = latitud
		this.longitud = longitud
	}
}
