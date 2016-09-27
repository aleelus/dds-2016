package controllers

import builders.BancoBuilder
import builders.CGPBuilder
import builders.ListaServiciosBuilder
import builders.LocalComBuilder
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.geodds.Point
import puntosDeInteres.Comuna
import puntosDeInteres.POI
import puntosDeInteres.ParadaColectivo
import repositorios.RepoPOI
import repositorios.RepoUsuarios
import usuario.Rol
import usuario.Terminal

class POIBootstrap{
	
	def static run() {
		
		// Builders
		val CGPBuilder builderCGP = new CGPBuilder()
		val ListaServiciosBuilder builderServicios = new ListaServiciosBuilder()
		val LocalComBuilder builderLocal = new LocalComBuilder()
		val BancoBuilder builderBanco = new BancoBuilder()
		
		
		
		
		// Un CGP
		builderCGP => [
			agregarServicios(builderServicios.crearServicios("Rentas", "Licencia de manejo", "Atención al jubilado"))
			setNombre("Centro Flores")
			setTags(newArrayList("CGP","Flores","Rentas"))
			setLongitud(1.4)
			setLatitud(1.2)
			setComuna("Flores",new Point(0, 0), new Point(2, 0), new Point(2, 2), new Point(0, 2))
			setDireccion = "Av. Corrientes 2873"
		]
		val cgp = builderCGP.build()
		
		// Un local
		builderLocal => [
			setNombre("Don José")
			setTags(newArrayList("José","Rotiseria","Barato"))
			setLongitud(0.9)
			setLatitud(1.3)
			setRubro("Rotiseria", 5)			
			setDireccion = "Quintana 861"
		]
		val localComercial = builderLocal.build()
		
		// 
		// Un local
		builderLocal => [
			setNombre("Don Yoyo")
			setTags(newArrayList("Yoyo", "Librería", "Barato"))
			setLongitud(1.5)
			setLatitud(-0.3)
			setRubro("Librería", 5)
			setDireccion = "Quintana 130"
		]
		val localComercialDos = builderLocal.build()
		
		
		// Una parada
		val parada = new ParadaColectivo("Parada Metrobús Caballito", 1.2, -1.6,"Malabia 29",newArrayList("24","60","124"))
		
		// Un banco
		builderBanco => [
			setNombre("Santander")
			setLongitud(1.2)
			setLatitud(0.7)
			setTags(newArrayList("Santander","Rio","Banco","Depósito","Cheque"))
			setSucursal("Once")
			setZona(new Comuna("Once",new Point(0, 0), new Point(50, 0), new Point(50, 50), new Point(0, 50)))
			setServicios(newArrayList("Cobro de cheques", "Depósitos", "Transferencias", "Extracciones"))
			setGerente("Mirtha Legrand")
			setDireccion = "Av. Rivadavia 3163"
		]
		val banco = builderBanco.build()
		 
		ApplicationContext.instance => [
			configureRepo(typeof(POI), new RepoPOI => [
				create(cgp)
				create(localComercial)
				create(localComercialDos)
				create(parada)
				create(banco)
			])
			configureRepo(typeof(Terminal), new RepoUsuarios => [
				create(new Terminal("ADMIN", new Rol(),"123",newArrayList(1,2),1,1))
				create(new Terminal("aleelus", new Rol(),"12345",newArrayList(2),-1,-1))
				create(new Terminal("terminal-1", new Rol(),"banana"))
			])
		]
	
	}
	
}