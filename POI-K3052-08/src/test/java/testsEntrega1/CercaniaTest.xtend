package testsEntrega1

import builders.CGPBuilder
import builders.LocalComBuilder
import java.util.ArrayList
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import puntosDeInteres.CGP
import puntosDeInteres.LocalComercial
import puntosDeInteres.ParadaColectivo
import puntosDeInteres.SucursalBanco

class CercaniaTest {
	CGP cgpCerca
	CGP cgpLejos
	LocalComercial localCercano
	LocalComercial localLejano
	ParadaColectivo paradaCercana
	ParadaColectivo paradaLejana
	SucursalBanco bancoCercano
	SucursalBanco bancoLejano
	Point puntoUsuario

	@Before
	def void setUp() {
		//Builders
		val CGPBuilder builderCGP = new CGPBuilder()
		val LocalComBuilder builderLocal = new LocalComBuilder()
		
		// Punto del usuario
		puntoUsuario = new Point(1, 1)
		
		// Creación del CGP
		builderCGP => [
			agregarServicios(new ArrayList())
			setNombre("Centro Flores")
			setLongitud(15)
			setLatitud(30)
			setComuna(new Point(0, 0), new Point(0, 2), new Point(2, 2), new Point(2, 0))
		]
		cgpCerca = builderCGP.build()
		builderCGP => [
			setComuna(new Point(2, 2), new Point(2, 4), new Point(4, 4), new Point(4, 2))
		]
		cgpLejos = builderCGP.build()
		 
		//Creación de Local Comercial
		builderLocal => [
			setNombre("Librería PPT")
			setLongitud(0.9)
			setLatitud(1.3)
			setRubro("Librería", 5)
		]
		localCercano = builderLocal.build()
		builderLocal => [
			setNombre("Kiosko DOC")
			setLongitud(1.2)
			setLatitud(1.7)
			setRubro("Kiosko", 2)
		]
		localLejano = builderLocal.build()

		// Ubicación paradas
		paradaCercana = new ParadaColectivo("110",1, 1.05)
		paradaLejana = new ParadaColectivo("124",2, 0)
		bancoCercano = new SucursalBanco(1.2, 0.7)
		bancoLejano = new SucursalBanco(0, 1)
	}

	@Test
	def testCercaniaCGPCercano() {
		Assert.assertTrue(cgpCerca.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaCGPLejano() {
		Assert.assertFalse(cgpLejos.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaParadaCercana() {
		Assert.assertTrue(paradaCercana.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaParadaLejana() {
		Assert.assertFalse(paradaLejana.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaLocalCercano() {
		Assert.assertTrue(localCercano.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaLocalLejano() {
		Assert.assertFalse(localLejano.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaPOICercano() {
		Assert.assertTrue(bancoCercano.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaPOILejano() {
		Assert.assertFalse(bancoLejano.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

}
