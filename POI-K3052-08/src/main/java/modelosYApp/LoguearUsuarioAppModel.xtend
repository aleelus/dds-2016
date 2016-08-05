package modelosYApp

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import repositorios.RepoUsuarios
import usuario.Terminal

@Observable
@Accessors
class LoguearUsuarioAppModel {
	String nombreTerminal
	String pass
	String passwordHardcodeada
	RepoUsuarios repo = ApplicationContext.instance.getSingleton(typeof(Terminal))
	
	new(String pass){
		passwordHardcodeada = pass
	}
	
	def limpiar() {
		nombreTerminal = ""
		pass = ""
	}
	
	def validarLogin() {
		if (!repo.existeUsuario(nombreTerminal)){
			throw new UserException("No existe el usuario indicado")
		} else if (pass!=passwordHardcodeada) {
			throw new UserException("Password incorrecta")
		}
	}
	
}