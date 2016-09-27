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
			setUrlIcono("http://static2.elblogverde.com/wp-content/uploads/2016/03/cuales-son-las-flores-del-verano-girasol-600x450.jpg")
			setLongitud(0.97)
			setLatitud(1.01)
			setComuna("Flores",new Point(0, 0), new Point(2, 0), new Point(2, 2), new Point(0, 2))
			setDireccion = "Av. Corrientes 2873"
		]
		val cgp = builderCGP.build()
		
		// Un local
		builderLocal => [
			setNombre("Don José")
			setTags(newArrayList("José","Rotiseria","Barato"))
			setUrlIcono("http://200.43.76.2:20009/website/file.php/transfer_files/2041//Iconos_web/rotiseria.jpg")
			setLongitud(0.99)
			setLatitud(1.11)
			setRubro("Rotiseria", 5)			
			setDireccion = "Quintana 861"
		]
		val localComercial = builderLocal.build()
		
		// 
		// Un local
		builderLocal => [
			setNombre("Don Yoyo")
			setTags(newArrayList("Yoyo", "Librería", "Barato"))
			setUrlIcono("http://previews.123rf.com/images/faysalfarhan/faysalfarhan1303/faysalfarhan130300010/18570071-Libro-azul-brillante-icono-refleja-bot-n-cuadrado-Foto-de-archivo.jpg")
			setLongitud(-1.15)
			setLatitud(-0.99)
			setRubro("Librería", 5)
			setDireccion = "Quintana 130"
		]
		val localComercialDos = builderLocal.build()
		
		
		// Una parada
		val parada = new ParadaColectivo("Parada Metrobús Caballito", 1.2, -1.6,"Malabia 29",newArrayList("24","60","124"),"https://image.freepik.com/iconos-gratis/silueta-bus-frontal_318-27514.png")

		// Un banco
		builderBanco => [
			setNombre("Santander")
			setUrlIcono("https://pbs.twimg.com/profile_images/610470794603405314/0-T5nIIv.png")
			setLongitud(1.12)
			setLatitud(0.98)
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