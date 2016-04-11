package domain

import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point
import org.junit.Assert
import java.util.ArrayList
import java.util.List

class DisponibilidadTest {
	
	CGP cgp
	ParadaColectivo colectivo
	LocalComercial local
	SucursalBanco banco
	List<ServicioCGP> listaServicios = new ArrayList<ServicioCGP>()
	List<String> horarios = new ArrayList<String>()
	List<String> diasAbierto = new ArrayList<String>()
	
	
	@Before
	def void setUp() {
		
		// Horarios del servicio Rentas
		horarios.add("2016-04-10T11:05:00")
		horarios.add("2016-04-10T15:00:00")
		horarios.add("2016-04-10T17:00:00")
		horarios.add("2016-04-10T21:30:00")
		//Dias del servicio Rentas
		diasAbierto.add("lunes")
		diasAbierto.add("martes")
		diasAbierto.add("miercoles")
		diasAbierto.add("jueves")
		diasAbierto.add("viernes")		
		val ServicioCGP unServicio = new ServicioCGP("Rentas",horarios,diasAbierto)
		listaServicios.add(unServicio)
				
		horarios = new ArrayList<String>()
		diasAbierto = new ArrayList<String>()
		
		// Horarios del servicio Educacion
		horarios.add("2016-04-10T09:00:00")
		horarios.add("2016-04-10T14:00:00")
		//Dias del servicio Educacion
		diasAbierto.add("lunes")
		diasAbierto.add("martes")
		diasAbierto.add("miercoles")
		diasAbierto.add("jueves")
		diasAbierto.add("viernes")		
		val ServicioCGP otroServicio = new ServicioCGP("Educacion",horarios,diasAbierto)
		listaServicios.add(otroServicio)
		
		horarios = new ArrayList<String>()
		diasAbierto = new ArrayList<String>()
		
		// Horarios del Banco
		horarios.add("2016-04-10T10:00:00")
		horarios.add("2016-04-10T15:00:00")
		diasAbierto.add("lunes")
		diasAbierto.add("martes")
		diasAbierto.add("miercoles")
		diasAbierto.add("jueves")
		diasAbierto.add("viernes")
		banco = new SucursalBanco(1.2,0.7,horarios,diasAbierto)
		
		
		
		horarios = new ArrayList<String>()
		diasAbierto = new ArrayList<String>()
		
		// Horarios del Comercio
		horarios.add("2016-04-10T10:00:00")
		horarios.add("2016-04-10T13:00:00")
		horarios.add("2016-04-10T17:00:00")
		horarios.add("2016-04-10T20:30:00")
		diasAbierto.add("lunes")
		diasAbierto.add("martes")
		diasAbierto.add("miercoles")
		diasAbierto.add("jueves")
		diasAbierto.add("viernes")
		diasAbierto.add("sabados")
		
		val Rubro carrousel = new Rubro("Librería", 5,horarios,diasAbierto)
		
		local = new LocalComercial(carrousel, 0.9, 1.3)
		
		
		
		val Comuna comuna1 = new Comuna(new Point(0, 0), new Point(0, 2), new Point(2, 2), new Point(2, 0))	
		cgp = new CGP(comuna1,listaServicios)
		
		
		// Ubicación paradas
		colectivo = new ParadaColectivo(1, 1.05)		
		
		
		
	}
	
	
	
	@Test
	def testDisponibilidadColectivos() {
		Assert.assertTrue(colectivo.estaDisponible("2016-04-10T20:30:00","Rentas"))
	}
	
	@Test
	def testDisponibilidadParaUnCGP_RentasDentroDelHorario() {				
			
		Assert.assertTrue(cgp.estaDisponible("2016-04-11T11:50:00","Rentas"))
		
	}
	
	@Test
	def testDisponibilidadParaUnCGP_RentasFueraDelHorario() {			
					
		Assert.assertFalse(cgp.estaDisponible("2016-04-11T09:50:00","Rentas"))
		
	}
	
	@Test
	def testDisponibilidadParaBanco_DentroDelHorario() {			
					
		Assert.assertTrue(banco.estaDisponible("2016-04-11T11:50:00","Banco Frances"))
		
	}
	
	@Test
	def testDisponibilidadParaBanco_FueraDelHorario() {			
					
		Assert.assertFalse(banco.estaDisponible("2016-04-11T08:50:00","Banco Frances"))
		
	}
	
	@Test
	def testDisponibilidadParaLocalComercialCarrousel_DentroDelHorario() {			
					
		Assert.assertTrue(local.estaDisponible("2016-04-11T11:20:00","Carrousel"))
		
	}
	
	@Test
	def testDisponibilidadParaLocalComercialCarrousel_FueraDelHorario() {			
					
		Assert.assertFalse(local.estaDisponible("2016-04-11T16:46:00","Carrousel"))
		
	}
	
	
	
	
}