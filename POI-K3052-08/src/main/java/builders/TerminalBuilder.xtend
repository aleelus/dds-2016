package builders

import repositorios.RepoPOI
import usuario.Terminal
import usuario.Rol

class TerminalBuilder {
	String nombreTerminal
	RepoPOI repositorio
	Rol rolTerminal

	def setNombre(String nombre) {
		nombreTerminal = nombre
		this
	}

	def setRepositorio(RepoPOI repo) {
		repositorio = repo
		this
	}
	
	def setRol(Rol rol){
		rolTerminal = rol
		this
	}
	
	def build(){
		val terminal = new Terminal()
		terminal.nombreTerminal = nombreTerminal
		terminal.repositorio = repositorio
		terminal.rolTerminal = rolTerminal
		terminal
	}}