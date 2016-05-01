package testsEntrega1

import domain.CGP
import domain.LocalComercial
import domain.ParadaColectivo
import domain.RepoPOI
import domain.Rubro
import domain.ServicioCGP
import domain.SucursalBanco
import java.util.ArrayList
import java.util.List
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import domain.POI

class BusquedaTest {
	RepoPOI mapa
	CGP cgp
	LocalComercial localComercial
	ParadaColectivo parada
	SucursalBanco banco
	SucursalBanco banco2
	SucursalBanco banco3
	StubBusquedaExternaBanco stubBusquedaBanco

	@Before
	def void SetUp() {

		// Mapa principal
		mapa = new RepoPOI()
		stubBusquedaBanco = new StubBusquedaExternaBanco()
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
		
		var List<String> listaServ = new ArrayList<String>
		listaServ.add("cobros cheques")
		listaServ.add("depositos")
		listaServ.add("transferencias")
		listaServ.add("extracciones")
		banco = new SucursalBanco(30, 40,"Santander", "Once",listaServ , "Mirtha Legrand")
		
		 listaServ = new ArrayList<String>
		listaServ.add("cobros cheques")
		listaServ.add("depositos")		
		banco2 = new SucursalBanco(30, 40, "Banco Nacion","Once",listaServ , "Mirtha Legrand")
		
		listaServ = new ArrayList<String>		
		listaServ.add("seguros")		
		banco3 = new SucursalBanco(50, 60, "Santander","Palermo",listaServ , "Christian de Lugano")
		
		var List<POI> listaPOI = new ArrayList<POI>
		
		listaPOI.add(banco)
		listaPOI.add(banco2)
		listaPOI.add(banco3)
		
		stubBusquedaBanco = new StubBusquedaExternaBanco(listaPOI)
		
		// Los agrego al mapa
//		mapa.agregarPOI(cgp)
//		mapa.agregarPOI(localComercial)
//		mapa.agregarPOI(parada)
//		mapa.agregarPOI(banco)
	}

	@Test
	def testBusquedaCGPOK() {
		Assert.assertTrue(mapa.search("Rentas").contains(cgp))
	}

	@Test
	def testBusquedaLocalOK() {
		Assert.assertTrue(mapa.search("Librería").contains(localComercial))
	}

	@Test
	def testBusquedaBancoOK() {
		Assert.assertTrue(stubBusquedaBanco.search("Santander").contains(banco))
	}
	@Test
	def testBusquedaBanco_NO_OK() {
		Assert.assertFalse(stubBusquedaBanco.search("Santander").contains(banco2))
	}

	@Test
	def testBusquedaParadaOK() {
		Assert.assertTrue(mapa.search("124").contains(parada))
	}

	@Test(expected=Exception)
	def testBusquedaFail() {
		Assert.assertTrue(mapa.search("Hospital").isEmpty)
	}
}
