package tests

import algoritmosFalla.EnvioMail
import algoritmosFalla.ReintentarProceso
import interfazUsuario.Rol
import interfazUsuario.Terminal
import observers.ObserverBusqueda
import org.junit.Before
import org.junit.Test
import procesos.ProcActualizacionLocal
import procesos.ProcAgregadoAcciones
import procesos.ProcBajaPoi
import procesos.ProcCompuesto
import repositorios.RepoPOI
import static org.mockito.Mockito.*

class ProcesosTest {
	RepoPOI mapa
	Terminal terminalEjecutora
	Terminal terminalNoEjecutora
	ProcActualizacionLocal procesoActualizacionLocales
	ProcBajaPoi procesoBajaPois
	ProcAgregadoAcciones procesoAgregadoAcciones
	ProcCompuesto procesoCompuesto
	
	
	@Before
	def void setUp(){
		// Repositorio
		mapa = new RepoPOI()

		// Creación de roles
		val rolAdmin = new Rol()
		rolAdmin.esAdmin()

		val rolConsulta = new Rol()
		rolConsulta.esUserConNotificacion()
		
		//Creación de terminales
		terminalEjecutora = new Terminal("abasto", mapa, rolAdmin)
		terminalNoEjecutora = new Terminal("caballito", mapa, rolConsulta)
		
		//Algoritmos de falla
		val algoritmoReenvio = new EnvioMail()
		val algoritmoReintento = new ReintentarProceso(1)
		
		//Procesos simples
		procesoActualizacionLocales = new ProcActualizacionLocal(algoritmoReenvio)
		val listaObservers = newArrayList(mock(ObserverBusqueda))
		procesoAgregadoAcciones = new ProcAgregadoAcciones(algoritmoReintento, listaObservers)
		procesoBajaPois = new ProcBajaPoi(algoritmoReenvio)
	}
	
	@Test
	def terminalNoAutorizada(){
		
	}
	
}