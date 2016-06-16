package tests

import adaptadores.AdaptadorMails
import adaptadores.AdaptadorServicioExterno
import adaptadores.InterfazActLocales
import adaptadores.InterfazAdmin
import adaptadores.InterfazREST
import algoritmosFalla.EnvioMail
import algoritmosFalla.ReintentarProceso
import algoritmosFalla.SinProceso
import builders.LocalComBuilder
import builders.ProcesoCompBuilder
import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import excepciones.AuthException
import interfazUsuario.Rol
import interfazUsuario.Terminal
import java.io.IOException
import java.nio.charset.Charset
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.ArrayList
import java.util.Arrays
import java.util.List
import observers.ObserverBusqueda
import org.joda.time.DateTime
import org.junit.After
import org.junit.AfterClass
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import procesos.ProcActualizacionLocal
import procesos.ProcAgregadoAcciones
import procesos.ProcBajaPoi
import procesos.ProcCompuesto
import puntosDeInteres.LocalComercial
import repositorios.HistorialProcesos
import repositorios.RepoPOI
import repositorios.RepoUsuarios

import static org.mockito.Matchers.*
import static org.mockito.Mockito.*

class ProcesosTest {
	RepoPOI mapa
	RepoUsuarios baseUsuarios
	Terminal terminalEjecutora
	Terminal terminalNoEjecutora
	ProcActualizacionLocal procesoActualizacionLocales
	ProcBajaPoi procesoBajaPois
	ProcAgregadoAcciones procesoAgregadoAcciones
	ProcCompuesto procesoCompuesto
	AdaptadorServicioExterno srvExt
	LocalComercial localComercial
	AdaptadorServicioExterno srvExtFail
	AdaptadorMails srvMails
	LocalComercial localComercialABorrar
	
	static Path archivo
	
//	ProcAgregadoAcciones procesoAgregadoAccionesRotas

	@Before
	def void setUp() {

		// Repositorios
		mapa = new RepoPOI
		baseUsuarios = new RepoUsuarios

		// Carga del repositorio
		val LocalComBuilder builderLocal = new LocalComBuilder()

		// Locales comerciales
		builderLocal => [
			setNombre("Don Julio")
			setTags(newArrayList("Julio", "Comida", "Barato"))
			setLongitud(5)
			setLatitud(10)
			setRubro("Restaurant", 5)
		]
		localComercial = builderLocal.build

		builderLocal => [
			setNombre("Don José")
			setTags(newArrayList("José", "Librería", "Barato"))
			setLongitud(5)
			setLatitud(10)
			setRubro("Librería", 5)
		]
		localComercialABorrar = builderLocal.build()

		mapa.create(localComercial)
		mapa.create(localComercialABorrar)

		// Creación de roles
		val rolAdmin = new Rol()
		rolAdmin.esAdmin()

		val rolConsulta = new Rol()
		rolConsulta.esUserConNotificacion()

		// Creación de terminales
		terminalEjecutora = new Terminal("abasto", mapa, rolAdmin)
		baseUsuarios.create(terminalEjecutora)
		terminalNoEjecutora = new Terminal("caballito", mapa, rolConsulta)
		baseUsuarios.create(terminalNoEjecutora)

		// Algoritmos de falla
		val InterfazAdmin mockMail = mock(InterfazAdmin)
		when(mockMail.recibirMail(anyString)).thenReturn(true)
		srvMails = new AdaptadorMails(mockMail)
		val algoritmoReenvio = new EnvioMail(srvMails)
		val algoritmoReintento = new ReintentarProceso(2)
		val sinAlgoritmo = new SinProceso

		// Interfaces correctas y fallidas
		val intRest = mock(InterfazREST)
		val intRestFallida = mock(InterfazREST)
		val intActLoc = mock(InterfazActLocales)
		val intActFallida = mock(InterfazActLocales)

		// Mockeo de interfaces 
		val listaObservers = newArrayList(mock(ObserverBusqueda))
//		val mockObserver = mock(ObserverBusqueda)
//		when(mockObserver.clone()).thenThrow(CloneNotSupportedException)
//		val listaObserversRotos = newArrayList(mockObserver)
		when(intRest.obtenerArchivoDeBajas).thenReturn(newArrayList("José", "Marcos").convertirAJSON)
		when(intRestFallida.obtenerArchivoDeBajas).thenThrow(ClassCastException)
		archivo = crearArchivoPruebaCorrecto
		when(intActLoc.obtenerArchivo).thenReturn(archivo)
		when(intActFallida.obtenerArchivo).thenThrow(IOException)
		

		// Servidor funcional y fallido
		srvExt = new AdaptadorServicioExterno(intActLoc, intRest)
		srvExtFail = new AdaptadorServicioExterno(intActFallida, intRestFallida)

		// Procesos simples
		procesoActualizacionLocales = new ProcActualizacionLocal("Proceso actualizador de locales", algoritmoReenvio,
			mapa, srvExt)
		procesoAgregadoAcciones = new ProcAgregadoAcciones("Proceso de adición de locales", algoritmoReintento,
			listaObservers, baseUsuarios)
//		procesoAgregadoAccionesRotas = new ProcAgregadoAcciones("Proceso de adición de locales", algoritmoReintento,
//			listaObserversRotos, baseUsuarios)
		procesoBajaPois = new ProcBajaPoi("Proceso de baja de POI", sinAlgoritmo, mapa, srvExt)

		// Proceso compuesto
		val builderProc = new ProcesoCompBuilder =>
			[
				agregarProcActualizacionLocales("Proceso de actualización de locales", sinAlgoritmo, mapa, srvExt)
				agregarProcAgregadoAcciones("Proceso de adición de acciones", algoritmoReenvio, listaObservers,
					baseUsuarios)
				agregarProcBajaPoi("Proceso de baja de POI", algoritmoReintento, mapa, srvExt)
			]
		procesoCompuesto = builderProc.build

	}

	/**Conversión a JSON de una lista de POI's a eliminar */
	def convertirAJSON(ArrayList<String> lista) {
		val JsonArray arrayPOIs = Json.array().asArray
		lista.forEach [ poi |
			var JsonObject poiJSON = Json.object()
			poiJSON.add("val_bus", poi)
			var dateTime = new DateTime
			poiJSON.add("dia_baja", dateTime.toString("dd"))
			poiJSON.add("mes_baja", dateTime.toString("MM"))
			poiJSON.add("año_baja", dateTime.toString("yy"))
			arrayPOIs.add(poiJSON)
		]
		arrayPOIs
	}

	/**Creación del archivo de prueba para actualización de locales */
	def crearArchivoPruebaCorrecto() {
		val List<String> lineas = Arrays.asList("Carrousel;colegio escolar uniformes modas",
			"Don Julio;comida urbana casera")
		var Path archivo = Paths.get("testArchivoAct.txt")
		Files.write(archivo, lineas, Charset.defaultCharset)
	}

	@Test(expected=AuthException)
	def terminalNoAutorizada() {
		terminalNoEjecutora.ejecutarProceso(procesoActualizacionLocales)
	}

	@Test
	def guardaEnHistorialOK() {
		terminalEjecutora.ejecutarProceso(procesoActualizacionLocales)
		Assert.assertTrue(HistorialProcesos.instance.contieneAOK(terminalEjecutora))
	}

	@Test
	def guardaEnHistorialFail() {
		procesoActualizacionLocales.adaptadorArchivo = srvExtFail
		terminalEjecutora.ejecutarProceso(procesoActualizacionLocales)
		procesoActualizacionLocales.adaptadorArchivo = srvExt
		Assert.assertTrue(HistorialProcesos.instance.contieneAError(terminalEjecutora))
	}

	@Test
	def ejecucionProcesoActualizacionOK() {
		terminalEjecutora.ejecutarProceso(procesoActualizacionLocales)
		Assert.assertArrayEquals(localComercial.tags, newArrayList("comida", "urbana", "casera"))
	}

	@Test
	def ejecucionProcesoActualizacionFallida() {
		procesoActualizacionLocales.adaptadorArchivo = srvExtFail
		terminalEjecutora.ejecutarProceso(procesoActualizacionLocales)
		srvMails.contieneMail(terminalEjecutora.nombreTerminal)
		procesoActualizacionLocales.adaptadorArchivo = srvExt
		
	}

	@Test
	def ejecucionProcesoBajaPOIOK() {
		terminalEjecutora.ejecutarProceso(procesoBajaPois)
		Assert.assertFalse(localComercialABorrar.estaHabilitado)
	}

	@Test
	def ejecucionProcesoBajaPOIFail() {
		procesoBajaPois.adaptadorREST = srvExtFail
		val algoritmoReintento = mock(ReintentarProceso)
		procesoBajaPois.algoritmoFalla = algoritmoReintento
		terminalEjecutora.ejecutarProceso(procesoBajaPois)
		verify(algoritmoReintento, times(1)).procesarFalla(terminalEjecutora.nombreTerminal, procesoBajaPois)
		procesoBajaPois.adaptadorREST = srvExt
	}

	@Test
	def ejecuccionProcesoAgregadoAccionesOK() {
		terminalEjecutora.ejecutarProceso(procesoAgregadoAcciones)
		Assert.assertTrue(baseUsuarios.chequearCantObservers(1))
	}

	@Test
	def ejecucionProcesoAgregadoAccionesFail() {
		val baseUsuariosRota = mock(RepoUsuarios)
		doThrow(CloneNotSupportedException).when(baseUsuariosRota).clonar
		procesoAgregadoAcciones.repositorioUsers = baseUsuariosRota
		terminalEjecutora.ejecutarProceso(procesoAgregadoAcciones)
		Assert.assertTrue(
			HistorialProcesos.instance.contieneErrorDeProceso(terminalEjecutora, procesoAgregadoAcciones))
	}

	@Test
	def ejecucionProcesoCompuesto() {
		terminalEjecutora.ejecutarProceso(procesoCompuesto)
		Assert.assertArrayEquals(localComercial.tags, newArrayList("comida", "urbana", "casera"))
		Assert.assertFalse(localComercialABorrar.estaHabilitado)
		Assert.assertTrue(baseUsuarios.chequearCantObservers(1))
	}

	@Test
	def deshacerEjecucion() {
		terminalEjecutora.ejecutarProceso(procesoAgregadoAcciones)
		terminalEjecutora.deshacerProcesoAcciones(procesoAgregadoAcciones)
		Assert.assertTrue(baseUsuarios.chequearCantObservers(0))
	}

	@After
	def limpiarSingletons() {
		HistorialProcesos.instance.limpiar
	}
	
	@AfterClass
	def static borrarArchivo(){
		Files.delete(archivo)
	}

}
