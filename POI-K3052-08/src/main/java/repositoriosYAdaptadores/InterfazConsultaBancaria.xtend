package repositoriosYAdaptadores

import com.eclipsesource.json.JsonArray
import puntosDeInteres.SucursalBanco

interface InterfazConsultaBancaria {
	
	def JsonArray consultar(String string)
	
	def void agregarSucursal(SucursalBanco banco)
	
	def void eliminarSucursal(SucursalBanco banco)
	
}