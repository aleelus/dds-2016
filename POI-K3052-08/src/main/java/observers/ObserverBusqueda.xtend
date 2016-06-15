package observers

import interfazUsuario.DatosBusqueda
import interfazUsuario.Terminal

interface ObserverBusqueda{
	
	def void update(Terminal terminal,DatosBusqueda datos)
}
