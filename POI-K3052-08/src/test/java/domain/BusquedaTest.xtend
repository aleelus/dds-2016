package domain

import java.util.ArrayList
import java.util.List
import org.junit.Before
import org.junit.Test
import org.junit.Assert

class BusquedaTest {
	Mapa mapa
	CGP cgp
	LocalComercial localComercial
	ParadaColectivo parada
	SucursalBanco banco

	@Before
	def void SetUp() {

		// Mapa principal
		mapa = new Mapa()
		// Un CGP
		val List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>
		val ServicioCGP rentas = new ServicioCGP("Rentas")
		listaServicios.add(rentas)
		val ServicioCGP licencia = new ServicioCGP("Licencia de Manejo")
		listaServicios.add(licencia)
		val ServicioCGP jubilacion = new ServicioCGP("Atención al Jubilado")
		listaServicios.add(jubilacion)
		cgp = new CGP("Centro Flores", listaServicios)
		// Un local
		val Rubro libreria = new Rubro("Librería", 5)
		localComercial = new LocalComercial(libreria, "Don José")
		// Una parada
		parada = new ParadaColectivo("124")
		// Un banco
		banco = new SucursalBanco("Banco Santander")
		// Los agrego al mapa
		mapa.listaPOI.add(cgp)
		mapa.listaPOI.add(localComercial)
		mapa.listaPOI.add(parada)
		mapa.listaPOI.add(banco)
	}

	@Test
	def testBusquedaCGPOK() {
		Assert.assertTrue(mapa.buscar("Rentas").contains(cgp))
	}

	@Test
	def testBusquedaLocalOK() {
		Assert.assertTrue(mapa.buscar("Librería").contains(localComercial))
	}

	@Test
	def testBusquedaBancoOK() {
		Assert.assertTrue(mapa.buscar("Santander").contains(banco))
	}

	@Test
	def testBusquedaParadaOK() {
		Assert.assertTrue(mapa.buscar("124").contains(parada))
	}

	@Test(expected=Exception)
	def testBusquedaFail() {
		Assert.assertTrue(mapa.buscar("Hospital").isEmpty)
	}

}
