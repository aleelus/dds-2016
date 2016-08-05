package observers

import usuario.Terminal
import usuario.DatosBusqueda

interface ObserverBusqueda{
	
	def void update(Terminal terminal,DatosBusqueda datos)
}
