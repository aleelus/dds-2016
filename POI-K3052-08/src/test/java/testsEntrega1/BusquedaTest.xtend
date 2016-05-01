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
import net.sf.oval.constraint.AssertTrue

class BusquedaTest {
	RepoPOI mapa
	CGP cgp
	LocalComercial localComercial
	ParadaColectivo parada
	ParadaColectivo parada2
	SucursalBanco banco
	SucursalBanco banco2
	SucursalBanco banco3
	StubBusquedaExternaBanco stubBusquedaBanco

	@Before
	def void SetUp() {

		// Orígenes de datos
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
		mapa.create(cgp)
		// Un local
		val Rubro libreria = new Rubro("Librería", 5)
		localComercial = new LocalComercial(libreria, "Don José")
		mapa.create(localComercial)
		// Paradas
		parada = new ParadaColectivo("124")
		parada2 = new ParadaColectivo("110")
		mapa.create(parada)
		// Bancos
		var List<String> listaServ = new ArrayList<String>
		listaServ.add("cobros cheques")
		listaServ.add("depositos")
		listaServ.add("transferencias")
		listaServ.add("extracciones")
		banco = new SucursalBanco(30, 40, "Santander", "Once", listaServ, "Mirtha Legrand")

		listaServ = new ArrayList<String>
		listaServ.add("cobros cheques")
		listaServ.add("depositos")
		banco2 = new SucursalBanco(30, 40, "Banco Nacion", "Once", listaServ, "Mirtha Legrand")

		listaServ = new ArrayList<String>
		listaServ.add("seguros")
		banco3 = new SucursalBanco(50, 60, "Santander", "Palermo", listaServ, "Christian de Lugano")

		var List<POI> listaPOI = new ArrayList<POI>

		listaPOI.add(banco)
		listaPOI.add(banco2)
		listaPOI.add(banco3)
		// Simulador del servicio externo para consulta de bancos
		stubBusquedaBanco = new StubBusquedaExternaBanco(listaPOI)

	}

	@Test
	def testCreacionPOI() {
		mapa.create(parada2)
		val ultimoID = mapa.allInstances.last.id
		Assert.assertTrue(mapa.allInstances.contains(parada2))
		Assert.assertEquals(parada2.id, ultimoID)
	}

	@Test
	def testEliminacionPOI() {
		mapa.delete(parada2)
		Assert.assertFalse(mapa.allInstances.contains(parada2))
	}

	@Test
	def testModificacionPOIExistente(){
		parada.nombre = "34"
		mapa.update(parada)
		Assert.assertTrue(mapa.searchByExample(parada).exists[punto | punto.nombre=="34"])
	}
	
	@Test (expected=Exception)
	def testModificacionPOIInvalido(){
		mapa.update(banco)
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
	
	@Test
	def testBusquedaPorID(){
		Assert.assertEquals(mapa.searchById(1),cgp)
	}

	@Test
	def testBusquedaVacia() {
		Assert.assertTrue(mapa.search("Hospital").isEmpty)
	}
}
