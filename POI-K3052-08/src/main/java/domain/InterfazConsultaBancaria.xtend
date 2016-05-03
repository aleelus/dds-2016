package domain

import com.eclipsesource.json.JsonArray

interface InterfazConsultaBancaria {
	
	def JsonArray consultar(String string)
	
	def void agregarSucursal(SucursalBanco banco)
	
	def void eliminarSucursal(SucursalBanco banco)
	
}