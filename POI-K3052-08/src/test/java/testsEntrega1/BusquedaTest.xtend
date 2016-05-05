package testsEntrega1

import java.util.ArrayList
import java.util.List
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import repositoriosYAdaptadores.RepoPOI
import puntosDeInteres.CGP
import puntosDeInteres.LocalComercial
import puntosDeInteres.ParadaColectivo
import puntosDeInteres.SucursalBanco
import repositoriosYAdaptadores.AdaptadorServicioExterno
import puntosDeInteres.ServicioCGP
import puntosDeInteres.Rubro
import repositoriosYAdaptadores.InterfazConsultaBancaria
import static org.mockito.Mockito.*
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import com.eclipsesource.json.Json

class BusquedaTest {
	RepoPOI mapa
	CGP cgp
	LocalComercial localComercial
	ParadaColectivo parada
	ParadaColectivo parada2
	SucursalBanco banco
	SucursalBanco banco2
	SucursalBanco banco3
	// StubBusquedaExternaBanco stubBusquedaBanco
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
		cgp = new CGP("Centro Flores", listaServicios, 15, 20)
		mapa.create(cgp)
		// Un local
		val Rubro libreria = new Rubro("Librería", 5)
		localComercial = new LocalComercial(libreria, "Don José", 5, 10)
		mapa.create(localComercial)
		// Paradas
		parada = new ParadaColectivo("124", 15, 15)
		parada2 = new ParadaColectivo("110", 40, 10)
		mapa.create(parada)
		mapa.create(parada2)
		// Bancos
		var List<String> listaServ = new ArrayList<String>
		listaServ.add("cobros cheques")
		listaServ.add("depositos")
		listaServ.add("transferencias")
		listaServ.add("extracciones")
		banco = new SucursalBanco(30, 40, "Santander", "Once", listaServ, "Mirtha Legrand")
		banco.id = mapa.allInstances.last.id + 1

		listaServ = new ArrayList<String>
		listaServ.add("cobros cheques")
		listaServ.add("depositos")
		banco2 = new SucursalBanco(30, 40, "Banco Nacion", "Once", listaServ, "Mirtha Legrand")
		banco2.id = banco.id + 1

		listaServ = new ArrayList<String>
		listaServ.add("seguros")
		banco3 = new SucursalBanco(50, 60, "Santander", "Palermo", listaServ, "Christian de Lugano")
		banco3.id = banco2.id + 1
		// Simulador del servicio externo para consulta de bancos
		// stubBusquedaBanco = new StubBusquedaExternaBanco()
		val InterfazConsultaBancaria mockSrvExt = mock(InterfazConsultaBancaria)
		val List<SucursalBanco> listaFiltradaMock = new ArrayList<SucursalBanco>
		listaFiltradaMock.add(banco)
		listaFiltradaMock.add(banco3)
		when(mockSrvExt.search("Santander")).thenReturn(listaFiltradaMock.convertirAJSON)

		adaptadorBanco = new AdaptadorServicioExterno(mockSrvExt)
	}

	/**Método que convierte una lista de sucursales bancarias a un String JSON*/
	def convertirAJSON(List<SucursalBanco> lista) {
		val JsonArray arraySucursales = Json.array().asArray
		lista.forEach [ sucursal |
			var JsonObject sucursalJSON = Json.object()
			sucursalJSON.add("banco", sucursal.nombre)
			sucursalJSON.add("x", sucursal.longitud)
			sucursalJSON.add("y", sucursal.latitud)
			sucursalJSON.add("sucursal", sucursal.nombreSucursal)
			sucursalJSON.add("gerente", sucursal.gerente)
			sucursalJSON.add("banco", sucursal.nombre)
			var JsonArray arrayServicios = Json.array(sucursal.servicios)
			sucursalJSON.add("servicios", arrayServicios)
			arraySucursales.add(sucursalJSON)
		]
		arraySucursales
	}

	@Test
	def testCreacionPOILocal() {
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

	@Test(expected=Exception)
	def testEliminacionPOIInvalido() {
		mapa.delete(banco)
	}

	@Test
	def testModificacionPOIExistente() {
		val ParadaColectivo paradaNueva = new ParadaColectivo("34", 10, 20)
		paradaNueva.id = parada.id
		mapa.update(paradaNueva)
		Assert.assertTrue(mapa.searchById(paradaNueva.id).nombre == "34")
	}

	@Test(expected=Exception)
	def testModificacionPOIInvalido() {
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
		Assert.assertTrue(adaptadorBanco.search("Santander").contains(banco))
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
	def testBusquedaPorID() {
		Assert.assertEquals(mapa.searchById(1), cgp)
	}

	@Test
	def testBusquedaVacia() {
		Assert.assertTrue(mapa.search("Hospital").isEmpty)
	}
}
