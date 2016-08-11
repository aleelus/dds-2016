package tests

import builders.CGPBuilder
import builders.ListaServiciosBuilder
import builders.LocalComBuilder
import java.util.ArrayList
import org.joda.time.LocalDate
import org.junit.Assert
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.uqbar.geodds.Point
import puntosDeInteres.CGP
import puntosDeInteres.LocalComercial

import static org.mockito.Matchers.*
import static org.mockito.Mockito.*
import observers.HistorialObs
import observers.AdministradorObs
import adaptadores.AdaptadorMails
import adaptadores.InterfazAdmin
import repositorios.RepoPOI
import repositorios.HistorialBusquedas
import usuario.Terminal
import usuario.DatosBusqueda
import usuario.Rol

class AccionesTest {
	RepoPOI mapa
	Terminal terminalAbasto
	Terminal terminalCaballito
	CGP cgp
	LocalComercial localComercial
	AdministradorObs observerNotificacion
	HistorialObs observerHistorial
	
	AdaptadorMails adaptadorMails

	@BeforeClass
	def static void setUpClase() {
		// Carga historial
		HistorialBusquedas.instance.agregar(new DatosBusqueda("Caballito", new LocalDate(2016, 05, 15), 1, 5, new ArrayList))
		HistorialBusquedas.instance.agregar(new DatosBusqueda("Abasto", new LocalDate(2016, 05, 15), 2, 10, new ArrayList))
		HistorialBusquedas.instance.agregar(new DatosBusqueda("Caballito", new LocalDate(2016, 05, 16), 3, 3, new ArrayList))
		HistorialBusquedas.instance.agregar(new DatosBusqueda("Abasto", new LocalDate(2016, 05, 16), 8, 8, new ArrayList))
		HistorialBusquedas.instance.agregar(new DatosBusqueda("Caballito", new LocalDate(2016, 05, 17), 0, 4, new ArrayList))
	}

	@Before
	def void setUpTest() {
		// Repositorio
		mapa = new RepoPOI()

		// Creación de roles
		val rolAdmin = new Rol()
		rolAdmin.esAdmin()

		val rolConsulta = new Rol()
		rolConsulta.esUserConNotificacion()

		// Builders
		val CGPBuilder builderCGP = new CGPBuilder()
		val ListaServiciosBuilder builderServicios = new ListaServiciosBuilder()
		val LocalComBuilder builderLocal = new LocalComBuilder()
		// Un CGP
		builderCGP => [
			agregarServicios(builderServicios.crearServicios("Rentas", "Licencia de manejo", "Atención al jubilado"))
			setNombre("Centro Flores")
			setTags(newArrayList("Santander","Rio","Banco","Depósito","Cheque"))
			setLongitud(15)
			setLatitud(30)
			setDireccion("Malabia 921")
			setComuna("Devoto",new Point(0, 0), new Point(50, 0), new Point(50, 50), new Point(0, 50))
		]
		cgp = builderCGP.build()

		// Un local
		builderLocal => [
			setNombre("Don José")
			setTags(newArrayList("José","Librería","Barato"))
			setLongitud(5)
			setLatitud(10)
			setRubro("Librería", 5)
		]
		localComercial = builderLocal.build()

		mapa.create(cgp)
		mapa.create(localComercial)

		// Terminales
		terminalAbasto = new Terminal("Abasto", rolAdmin, mapa)
		terminalAbasto.repositorio = mapa
		terminalCaballito = new Terminal("Caballito", rolConsulta, mapa)
		terminalCaballito.repositorio = mapa

		// Observers
		val InterfazAdmin mockMail = mock(InterfazAdmin)
		adaptadorMails = new AdaptadorMails(mockMail)
		observerNotificacion = new AdministradorObs(1, adaptadorMails)
		when(mockMail.recibirMail(anyString, anyLong)).thenReturn(true)
		observerHistorial = new HistorialObs()
		terminalAbasto.agregarObserver(observerNotificacion)
		terminalAbasto.agregarObserver(observerHistorial)
		terminalCaballito.agregarObserver(observerHistorial)

	}

	@Test
	def busquedaGuardadaEnHistorial() {
		terminalAbasto.search("Flores")
		Assert.assertTrue(HistorialBusquedas.instance.contieneA(cgp))
	}

	@Test(expected=Exception)
	def terminalNoAutorizadaReporteFecha() {
		Assert.assertEquals(terminalCaballito.generarReporteFecha(), void)
	}

	@Test(expected=Exception)
	def terminalNoAutorizadaReporteTerminal() {
		Assert.assertEquals(terminalCaballito.generarReporteTerminal, void)
	}

	@Test
	def terminalAutorizadaAEnviarMailsConAviso() {
		observerNotificacion.actualizarTiempo(10)
		terminalAbasto.search("Don")
		Assert.assertTrue(adaptadorMails.contieneMail(terminalAbasto.nombreTerminal))
	}

	@Test
	def terminalAutorizadaAEnviarMailsSinAviso() {
		observerNotificacion.actualizarTiempo(10000)
		terminalAbasto.search("Flores")
		Assert.assertFalse(adaptadorMails.contieneMail(terminalAbasto.nombreTerminal))
	}
	@Test
	def terminalAutorizadaAReporteFecha() {
		val resultado = terminalAbasto.generarReporteFecha()
		Assert.assertEquals(resultado.get(new LocalDate(2016, 05, 15)), 15)
	}

	@Test(expected=Exception)
	def terminalNoAutorizadaAReporteFecha() {
		Assert.assertEquals(terminalCaballito.generarReporteFecha(), void)
	}

	@Test
	def terminalAutorizadaAReporteTerminal() {
		val resultado = terminalAbasto.generarReporteTerminal()
		Assert.assertTrue(resultado.get("Abasto").containsAll(newArrayList(10, 8)))
	}

	@Test(expected=Exception)
	def terminalNoAutorizadaAReporteTerminal() {
		Assert.assertEquals(terminalCaballito.generarReporteTerminal(), void)
	}

	@Test
	def terminalAutorizadaReporteTotalTerminal() {
		val resultado = terminalAbasto.generarReporteTotalesTerminal()
		Assert.assertEquals(resultado.get("Caballito"), 12)
	}
}
