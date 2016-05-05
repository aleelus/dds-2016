package repositoriosYAdaptadores

import com.eclipsesource.json.JsonArray

interface InterfazConsultaBancaria {
	
	def JsonArray search(String string)
}