package domain

import com.eclipsesource.json.JsonArray

interface InterfazConsultaBancaria {
	
	def JsonArray consultar(String string)
	
}