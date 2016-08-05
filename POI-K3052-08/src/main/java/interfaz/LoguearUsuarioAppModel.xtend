package interfaz

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Dependencies
import org.uqbar.commons.utils.Observable
import org.uqbar.commons.model.UserException

@Observable
@Accessors
class LoguearUsuarioAppModel {
	String nombreTerminal
	String pass
	String passwordHardcodeada
	
	new(String pass){
		passwordHardcodeada = pass
	}
	
	def limpiar() {
		nombreTerminal = ""
		pass = ""
	}
	
	@Dependencies("pass")
	def getPasswordOK() {
		pass.equals(passwordHardcodeada)
	}
	
	def validarLogin() {
		if (pass!=passwordHardcodeada) {
			throw new UserException("Password incorrecta")
		}
	}
	
}