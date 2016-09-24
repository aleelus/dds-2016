package tests

import builders.BancoBuilder
import builders.CGPBuilder
import builders.ListaServiciosBuilder
import builders.LocalComBuilder
import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import java.util.List
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import puntosDeInteres.CGP
import puntosDeInteres.LocalComercial
import puntosDeInteres.ParadaColectivo
import puntosDeInteres.SucursalBanco


import static org.mockito.Mockito.*
import adaptadores.AdaptadorServicioExterno
import adaptadores.InterfazConsultaBancaria
import repositorios.RepoPOI

class BusquedaTest{
	// Origen de datos
	RepoPOI mapa = new RepoPOI()
	CGP cgp
	LocalComercial localComercial
	ParadaColectivo parada
	ParadaColectivo parada2
	SucursalBanco banco
	SucursalBanco banco2
	SucursalBanco banco3
	AdaptadorServicioExterno adaptadorBanco
	
	@Before
	def void SetUp() {
		
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
			setLongitud(15)
			setLatitud(30)
			setDireccion = "Malabia 312"
			setComuna("Flores",new Point(0, 0), new Point(50, 0), new Point(50, 50), new Point(0, 50))
		]
		cgp = builderCGP.build()

		// Un local
		builderLocal => [
			setNombre("Don José")
			setTags(newArrayList("José","Librería","Barato"))
			setLongitud(5)
			setLatitud(10)
			setDireccion = "Campana 2412"
			setRubro("Librería", 5)
		]
		localComercial = builderLocal.build()

		// Paradas
		parada = new ParadaColectivo("124", 15, 15,"Campana 132",newArrayList("24","60","124"))
		parada2 = new ParadaColectivo("110", 40, 10, "Cuenca 451",newArrayList("24","60","124"))

		// Agrego los POI's al repositorio externo
		mapa.create(cgp)
		mapa.create(localComercial)
		mapa.create(parada)
		mapa.create(parada2)

		// Bancos
		builderBanco => [
			setNombre("Santander")
			setLongitud(30)
			setLatitud(40)
			setTags(newArrayList("Santander","Rio","Banco","Depósito","Cheque"))
			setSucursal("Once")
			setDireccion = "Cuenca 981"
			setServicios(newArrayList("cobros cheques", "depositos", "transferencias", "extracciones"))
			setGerente("Mirtha Legrand")
		]
		banco = builderBanco.build()
		banco.id = mapa.allInstances.last.id + 1
		
		mapa.create(banco)

		builderBanco => [
			setNombre("Banco Nacion")
			setLongitud(40)
			setLatitud(60)
			setSucursal("Once")
			setServicios(newArrayList("cobros cheques", "depositos"))
			setGerente("Mirtha Legrand")
		]
		banco2 = builderBanco.build()
		banco2.id = banco.id + 1

		builderBanco => [
			setNombre("Santander")
			setLongitud(50)
			setLatitud(60)
			setSucursal("Palermo")
			setServicios(newArrayList("seguros"))
			setGerente("Christian de Lugano")
		]
		banco3 = builderBanco.build()
		banco3.id = banco2.id + 1
		
		//Mockeo del servicio externo
		val InterfazConsultaBancaria mockSrvExt = mock(InterfazConsultaBancaria)
		val List<SucursalBanco> listaFiltradaMock = newArrayList(banco,banco3)
		when(mockSrvExt.search("Santander")).thenReturn(listaFiltradaMock.convertirAJSON)
		busquedasVacias(mockSrvExt, "Hospital", "Librería", "124", "Rentas")
		adaptadorBanco = new AdaptadorServicioExterno(mockSrvExt)
		mapa.agregarSrv(adaptadorBanco)
	}
	
	/**Método donde se definen las búsquedas vacías del mock */
	def static busquedasVacias(InterfazConsultaBancaria mock, String... busquedas) {
		busquedas.forEach[busqueda|when(mock.search(busqueda)).thenReturn(new JsonArray)]
	}

	/**Método que convierte una lista de sucursales bancarias a un String JSON*/
	def static convertirAJSON(List<SucursalBanco> lista) {
		val JsonArray arraySucursales = Json.array().asArray
		lista.forEach [ sucursal |
			var JsonObject sucursalJSON = Json.object()
			sucursalJSON.add("banco", sucursal.nombre)
			sucursalJSON.add("x", sucursal.longitud)
			sucursalJSON.add("y", sucursal.latitud)
			sucursalJSON.add("sucursal", sucursal.nombreSucursal)
			sucursalJSON.add("gerente", sucursal.gerente)
			sucursalJSON.add("banco", sucursal.nombre)
			var JsonArray arrayServicios = Json.array(sucursal.listaServicios)
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
		mapa.delete(banco2)
	}

	@Test
	def testModificacionPOIExistente() {
		val ParadaColectivo paradaNueva = new ParadaColectivo("Parada 03", 10, 20,"Helguera 1382",newArrayList("24","60","124"))
		paradaNueva.id = parada.id
		mapa.update(paradaNueva)
		Assert.assertTrue(mapa.searchById(paradaNueva.id).nombre == "Parada 03")
	}

	@Test(expected=Exception)
	def testModificacionPOIInvalido() {
		mapa.update(banco2)
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
		Assert.assertTrue(mapa.search("Santander").contains(banco))
	}

	@Test
	def testBusquedaBanco_NO_OK() {
		Assert.assertFalse(mapa.search("Santander").contains(banco2))
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
