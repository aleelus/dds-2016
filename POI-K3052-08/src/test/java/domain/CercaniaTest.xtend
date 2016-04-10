package domain

import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import org.junit.Assert

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
		// Punto del usuari
		puntoUsuario = new Point(1, 1)
		// Puntos del CGP
		val Comuna comuna1 = new Comuna(new Point(0, 0), new Point(0, 2), new Point(2, 2), new Point(2, 0))
		val Comuna comuna2 = new Comuna(new Point(2, 2), new Point(2, 4), new Point(4, 4), new Point(4, 2))
		cgpCerca = new CGP(comuna1)
		cgpLejos = new CGP(comuna2)
		// Rubros del local
		val Rubro libreria = new Rubro("Librería", 5)
		val Rubro kiosco = new Rubro("Kiosco", 2)
		localCercano = new LocalComercial(libreria, 0.9, 1.3)
		localLejano = new LocalComercial(kiosco, 1.2, 1.7)
		// Ubicación paradas
		paradaCercana = new ParadaColectivo(1, 1.05)
		paradaLejana = new ParadaColectivo(2, 0)
		bancoCercano = new SucursalBanco(1.2,0.7)
		bancoLejano = new SucursalBanco(0,1)
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
