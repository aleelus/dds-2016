package testsEntrega1

import domain.AdaptadorServicioExterno
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
	AdaptadorServicioExterno adaptadorBanco

	@Before
	def void SetUp() {

		// Orígenes de datos
		mapa = new RepoPOI()
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

		var List<SucursalBanco> listaBancos = new ArrayList<SucursalBanco>

		listaBancos.add(banco)
		listaBancos.add(banco2)
		listaBancos.add(banco3)
		// Simulador del servicio externo para consulta de bancos
		stubBusquedaBanco = new StubBusquedaExternaBanco(listaBancos)
		adaptadorBanco = new AdaptadorServicioExterno(stubBusquedaBanco)

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
		Assert.assertTrue(adaptadorBanco.search("Santander").forall[banco |banco.nombre == banco.nombre])
	}

	@Test
	def testBusquedaBanco_NO_OK() {
		Assert.assertFalse(adaptadorBanco.search("Santander").contains(banco2))
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
