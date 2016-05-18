package tests

import builders.CGPBuilder
import builders.ListaServiciosBuilder
import interfazUsuario.Terminal
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import repositoriosYAdaptadores.RepoPOI
import org.junit.Assert
import interfazUsuario.Historial
import puntosDeInteres.CGP
import builders.LocalComBuilder
import puntosDeInteres.LocalComercial
import interfazUsuario.DatosBusqueda
import org.joda.time.LocalDate
import java.util.ArrayList
import org.junit.BeforeClass
import interfazUsuario.AdministradorObs
import interfazUsuario.HistorialObs

class AccionesTest {
	RepoPOI mapa
	Terminal terminalAbasto
	Terminal terminalCaballito
	CGP cgp
	LocalComercial localComercial
	AdministradorObs observerNotificacion
	HistorialObs observerHistorial

	@BeforeClass
	def static void setUpClase() {
		// Carga historial
		Historial.instance.agregar(new DatosBusqueda("Caballito", new LocalDate(2016, 05, 15), 1, 5, new ArrayList))
		Historial.instance.agregar(new DatosBusqueda("Abasto", new LocalDate(2016, 05, 15), 2, 10, new ArrayList))
		Historial.instance.agregar(new DatosBusqueda("Caballito", new LocalDate(2016, 05, 16), 3, 3, new ArrayList))
		Historial.instance.agregar(new DatosBusqueda("Abasto", new LocalDate(2016, 05, 16), 8, 8, new ArrayList))
		Historial.instance.agregar(new DatosBusqueda("Caballito", new LocalDate(2016, 05, 17), 0, 4, new ArrayList))
	}

	@Before
	def void setUpTest() {
		// Repositorio
		mapa = new RepoPOI()

		// Builders
		val CGPBuilder builderCGP = new CGPBuilder()
		val ListaServiciosBuilder builderServicios = new ListaServiciosBuilder()
		val LocalComBuilder builderLocal = new LocalComBuilder()
		// Un CGP
		builderCGP => [
			agregarServicios(builderServicios.crearServicios("Rentas", "Licencia de manejo", "Atención al jubilado"))
			setNombre("Centro Flores")
			setLongitud(15)
			setLatitud(30)
			setComuna(new Point(0, 0), new Point(50, 0), new Point(50, 50), new Point(0, 50))
		]
		cgp = builderCGP.build()

		// Un local
		builderLocal => [
			setNombre("Don José")
			setLongitud(5)
			setLatitud(10)
			setRubro("Librería", 5)
		]
		localComercial = builderLocal.build()

		mapa.create(cgp)
		mapa.create(localComercial)

		// Terminales
		terminalAbasto = new Terminal("Abasto", mapa)
		terminalCaballito = new Terminal("Caballito", mapa)


		// Observers
		observerNotificacion = new AdministradorObs(1)
		observerHistorial = new HistorialObs()
		terminalAbasto.agregarObserverBus(observerNotificacion)
		terminalAbasto.agregarObserverBus(observerHistorial)
		terminalCaballito.agregarObserverBus(observerHistorial)
		
	}

	@Test
	def busquedaGuardadaEnHistorial() {
		terminalAbasto.search("Flores")
		Assert.assertTrue(Historial.instance.contieneA(cgp))
	}

	//@Test(expected=Exception)
	def terminalNoAutorizadaReporteFecha() {
		Assert.assertEquals(terminalAbasto.generarReporteFecha(), void)
	}

	//@Test(expected=Exception)
	def terminalNoAutorizadaReporteTerminal() {
		Assert.assertEquals(terminalAbasto.generarReporteTerminal, void)
	}

	@Test
	def terminalAutorizadaAEnviarMailsConAviso() {
		observerNotificacion.actualizarTiempo(10)
		terminalAbasto.search("Don")
		Assert.assertTrue(observerNotificacion.envioMail())
	}

	@Test
	def terminalAutorizadaAEnviarMailsSinAviso() {
		observerNotificacion.actualizarTiempo(1000)
		terminalAbasto.search("Flores")
		Assert.assertFalse(observerNotificacion.envioMail())
	}

	@Test
	def terminalAutorizadaAReporteFecha() {
		val resultado = terminalAbasto.generarReporteFecha()
		Assert.assertEquals(resultado.get(new LocalDate(2016, 05, 15)), 15)
	}

	//@Test(expected=Exception)
	def terminalNoAutorizadaAReporteFecha() {
		Assert.assertEquals(terminalCaballito.generarReporteFecha(), void)
	}

	@Test
	def terminalAutorizadaAReporteTerminal() {
		val resultado = terminalAbasto.generarReporteTerminal()
		Assert.assertTrue(resultado.get("Abasto").containsAll(newArrayList(10, 8)))
	}

	//@Test(expected=Exception)
	def terminalNoAutorizadaAReporteTerminal() {
		Assert.assertEquals(terminalCaballito.generarReporteTerminal(), void)
	}

	@Test
	def terminalAutorizadaReporteTotalTerminal() {
		val resultado = terminalAbasto.generarReporteTotalesTerminal()
		Assert.assertEquals(resultado.get("Caballito"), 12)
	}
}
