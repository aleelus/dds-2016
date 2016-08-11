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
	RepoUsuarios repo = ApplicationContext.instance.getSingleton(typeof(Terminal))
	
	def limpiar() {
		nombreTerminal = ""
		pass = ""
	}
	
	def validarLogin() {
		if (!repo.existeUsuario(nombreTerminal)){
			throw new UserException("No existe el usuario indicado")
		} else if (repo.coincidePass(nombreTerminal,pass)) {
			throw new UserException("Password incorrecta")
		}
	}
	
}