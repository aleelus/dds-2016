package testsEntrega1

import java.util.ArrayList
import java.util.List
import org.joda.time.DateTime
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import puntosDeInteres.CGP
import puntosDeInteres.ParadaColectivo
import puntosDeInteres.LocalComercial
import puntosDeInteres.SucursalBanco
import puntosDeInteres.ServicioCGP
import puntosDeInteres.POI.Dias
import puntosDeInteres.Rubro
import puntosDeInteres.Comuna

class DisponibilidadTest {

	CGP cgp
	ParadaColectivo colectivo
	LocalComercial local
	SucursalBanco banco
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()
	List<DateTime> horarios = new ArrayList<DateTime>()
	List<Dias> diasAbierto = new ArrayList<Dias>()

	@Before
	def void setUp() {

		var DateTime dt

		// Horarios del servicio Rentas
		dt = new DateTime("2016-04-10T11:05:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T15:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T17:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T21:30:00")
		horarios.add(dt)
		// Dias del servicio Rentas
		diasAbierto.add(Dias.lunes)
		diasAbierto.add(Dias.martes)
		diasAbierto.add(Dias.miercoles)
		diasAbierto.add(Dias.jueves)
		diasAbierto.add(Dias.viernes)
		val ServicioCGP unServicio = new ServicioCGP("Rentas", horarios, diasAbierto)
		listaServicios.add(unServicio)

		horarios = new ArrayList<DateTime>()
		diasAbierto = new ArrayList<Dias>()

		// Horarios del servicio Educacion
		dt = new DateTime("2016-04-10T09:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T14:00:00")
		horarios.add(dt)
		// Dias del servicio Educacion
		diasAbierto.add(Dias.lunes)
		diasAbierto.add(Dias.martes)
		diasAbierto.add(Dias.miercoles)
		diasAbierto.add(Dias.jueves)
		diasAbierto.add(Dias.viernes)
		val ServicioCGP otroServicio = new ServicioCGP("Educacion", horarios, diasAbierto)
		listaServicios.add(otroServicio)

		horarios = new ArrayList<DateTime>()
		diasAbierto = new ArrayList<Dias>()

		// Horarios del Banco
		dt = new DateTime("2016-04-10T10:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T15:00:00")
		horarios.add(dt)
		diasAbierto.add(Dias.lunes)
		diasAbierto.add(Dias.martes)
		diasAbierto.add(Dias.miercoles)
		diasAbierto.add(Dias.jueves)
		diasAbierto.add(Dias.viernes)
		banco = new SucursalBanco(1.2, 0.7, horarios, diasAbierto)

		horarios = new ArrayList<DateTime>()
		diasAbierto = new ArrayList<Dias>()

		// Horarios del Comercio
		dt = new DateTime("2016-04-10T10:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T13:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T17:00:00")
		horarios.add(dt)
		dt = new DateTime("2016-04-10T20:30:00")
		horarios.add(dt)
		diasAbierto.add(Dias.lunes)
		diasAbierto.add(Dias.martes)
		diasAbierto.add(Dias.miercoles)
		diasAbierto.add(Dias.jueves)
		diasAbierto.add(Dias.viernes)
		diasAbierto.add(Dias.sabado)

		val Rubro carrousel = new Rubro("Librería", 5, horarios, diasAbierto)

		local = new LocalComercial(carrousel, "Carrusel Minguito", 0.9, 1.3)

		val Comuna comuna1 = new Comuna(new Point(0, 0), new Point(0, 2), new Point(2, 2), new Point(2, 0))
		cgp = new CGP(comuna1, listaServicios)

		// Ubicación paradas
		colectivo = new ParadaColectivo("34",1, 1.05)

	}

	@Test
	def testDisponibilidadColectivos() {
		val DateTime dt = new DateTime("2016-04-10T20:30:00")

		Assert.assertTrue(colectivo.estaDisponible(dt, "Rentas"))
	}

	@Test
	def testDisponibilidadParaUnCGP_RentasDentroDelHorario() {
		val DateTime dt = new DateTime("2016-04-11T11:50:00")
		Assert.assertTrue(cgp.estaDisponible(dt, "Rentas"))

	}

	@Test
	def testDisponibilidadParaUnCGP_RentasFueraDelHorario() {
		val DateTime dt = new DateTime("2016-04-10T09:50:00")
		Assert.assertFalse(cgp.estaDisponible(dt, "Rentas"))

	}

	@Test
	def testDisponibilidadParaBanco_DentroDelHorario() {
		val DateTime dt = new DateTime("2016-04-11T11:50:00")
		Assert.assertTrue(banco.estaDisponible(dt, "Banco Frances"))

	}

	@Test
	def testDisponibilidadParaBanco_FueraDelHorario() {
		val DateTime dt = new DateTime("2016-04-11T08:50:00")
		Assert.assertFalse(banco.estaDisponible(dt, "Banco Frances"))

	}

	@Test
	def testDisponibilidadParaLocalComercialCarrousel_DentroDelHorario() {
		val DateTime dt = new DateTime("2016-04-11T11:20:00")
		Assert.assertTrue(local.estaDisponible(dt, "Carrousel"))

	}

	@Test
	def testDisponibilidadParaLocalComercialCarrousel_FueraDelHorario() {
		val DateTime dt = new DateTime("2016-04-11T16:46:00")
		Assert.assertFalse(local.estaDisponible(dt, "Carrousel"))

	}

}
