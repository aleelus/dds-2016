package domain

import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import org.junit.Assert

class CercaniaTest {
	CGP cgpCerca
	CGP cgpLejos
	LocalComercial local
	ParadaColectivo parada
	SucursalBanco banco
	Point puntoUsuario

	@Before
	def void setUp() {
		puntoUsuario = new Point(1, 1)
		val Comuna comuna1 = new Comuna(new Point(0, 0), new Point(0, 2), new Point(2, 2), new Point(2, 0))
		val Comuna comuna2 = new Comuna(new Point(2, 2), new Point(2, 4), new Point(4, 4), new Point(4, 2))
		cgpCerca = new CGP(comuna1)
		cgpLejos = new CGP(comuna2)
		local = new LocalComercial()
		parada = new ParadaColectivo()
		banco = new SucursalBanco()
	}

	@Test
	def testCercaniaCGPCercano() {
		Assert.assertTrue(cgpCerca.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}

	@Test
	def testCercaniaCGPLejano() {
		Assert.assertFalse(cgpLejos.estaCerca(puntoUsuario.latitude, puntoUsuario.longitude))
	}
}
