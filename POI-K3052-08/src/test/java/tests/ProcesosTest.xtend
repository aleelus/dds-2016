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
import procesos.Proceso
import usuario.Terminal
import usuario.Rol
import org.uqbar.commons.utils.ApplicationContext
import puntosDeInteres.POI

class ProcesosTest {
	RepoPOI mapa
	RepoUsuarios baseUsuarios
	RepoUsuarios baseUsuariosRota
	Terminal terminalEjecutora
	Terminal terminalNoEjecutora
	ProcActualizacionLocal procesoActualizacionLocales
	ProcBajaPoi procesoBajaPois
	ProcAgregadoAcciones procesoAgregadoAcciones
	ProcCompuesto procesoCompuesto
	ProcCompuesto procesoCompuestoFail
	AdaptadorServicioExterno srvExt
	LocalComercial localComercial
	AdaptadorServicioExterno srvExtFail
	AdaptadorMails srvMails
	LocalComercial localComercialABorrar

	static Path archivo

	@Before
	def void setUp() {

		// Carga del repositorio
		val LocalComBuilder builderLocal = new LocalComBuilder()

		// Locales comerciales
		builderLocal => [
			setNombre("Don Julio")
			setTags(newArrayList("Julio", "Comida", "Barato"))
			setLongitud(5)
			setLatitud(10)
			setRubro("Restaurant", 5)
			setDireccion("Quintana 861")
		]
		localComercial = builderLocal.build

		builderLocal => [
			setNombre("Don José")
			setTags(newArrayList("José", "Librería", "Barato"))
			setLongitud(5)
			setLatitud(10)
			setRubro("Librería", 5)
			setDireccion("Quintana 123")
		]
		localComercialABorrar = builderLocal.build()

		// Repositorios
		ApplicationContext.instance => [
			configureRepo(typeof(POI), new RepoPOI => [
				create(localComercial)
				create(localComercialABorrar)
			])
		]

		mapa = ApplicationContext.instance.getRepo(typeof(POI)) as RepoPOI

		// Creación de roles
		val rolAdmin = new Rol()
		rolAdmin.esAdmin()

		val rolConsulta = new Rol()
		rolConsulta.esUserConNotificacion()

		// Creación de terminales
		terminalEjecutora = new Terminal("abasto", rolAdmin)

		terminalNoEjecutora = new Terminal("caballito", rolConsulta)

		ApplicationContext.instance => [
			configureRepo(typeof(Terminal), new RepoUsuarios => [
				create(terminalEjecutora)
				create(terminalNoEjecutora)
			])
		]

		baseUsuarios = ApplicationContext.instance.getRepo(typeof(Terminal)) as RepoUsuarios
		baseUsuariosRota = new RepoUsuarios
		baseUsuariosRota.create(terminalEjecutora)
		baseUsuariosRota.create(terminalNoEjecutora)

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
		when(intRest.obtenerArchivoDeBajas).thenReturn(newArrayList("José", "Marcos").convertirAJSON)
		when(intRestFallida.obtenerArchivoDeBajas).thenThrow(ClassCastException)
		archivo = crearArchivoPruebaCorrecto
		when(intActLoc.obtenerArchivo).thenReturn(archivo)
		when(intActFallida.obtenerArchivo).thenThrow(IOException)
		baseUsuariosRota = mock(RepoUsuarios)
		doThrow(CloneNotSupportedException).when(baseUsuariosRota).clonar

		// Servidor funcional y fallido
		srvExt = new AdaptadorServicioExterno(intActLoc, intRest)
		srvExtFail = new AdaptadorServicioExterno(intActFallida, intRestFallida)

		// Procesos simples
		procesoActualizacionLocales = new ProcActualizacionLocal("Proceso actualizador de locales", algoritmoReenvio,
			mapa, srvExt)
		procesoAgregadoAcciones = new ProcAgregadoAcciones("Proceso de adición de locales", sinAlgoritmo,
			listaObservers, baseUsuarios)
		procesoBajaPois = new ProcBajaPoi("Proceso de baja de POI", algoritmoReintento, mapa, srvExt)

		// Proceso compuesto
		val builderProc = new ProcesoCompBuilder =>
			[
				agregarProcActualizacionLocales("Proceso de actualización de locales", sinAlgoritmo, mapa, srvExt)
				agregarProcAgregadoAcciones("Proceso de adición de acciones", algoritmoReenvio, listaObservers,
					baseUsuarios)
				agregarProcBajaPoi("Proceso de baja de POI", algoritmoReintento, mapa, srvExt)
			]
		procesoCompuesto = builderProc.build

		// Proceso compuesto con errores
		builderProc =>
			[
				agregarProcActualizacionLocales("Proceso de actualización de locales", algoritmoReenvio, mapa,
					srvExtFail)
				agregarProcAgregadoAcciones("Proceso de adición de acciones", sinAlgoritmo, listaObservers,
					baseUsuariosRota)
				agregarProcBajaPoi("Proceso de baja de POI", algoritmoReintento, mapa, srvExtFail)
			]
		procesoCompuestoFail = builderProc.build

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
		procesoActualizacionLocales.adaptadorArchivo = srvExt
		Assert.assertTrue(srvMails.contieneMail(terminalEjecutora.nombreTerminal))

	}

	@Test
	def ejecucionProcesoBajaPOIOK() {
		terminalEjecutora.ejecutarProceso(procesoBajaPois)
		Assert.assertFalse(localComercialABorrar.estaHabilitado)
	}

	@Test
	def ejecucionProcesoBajaPOIFail() {
		procesoBajaPois.adaptadorREST = srvExtFail
		val algoritmoReintento = spy(new ReintentarProceso(1))
		procesoBajaPois.algoritmoFalla = algoritmoReintento
		terminalEjecutora.ejecutarProceso(procesoBajaPois)
		verify(algoritmoReintento, times(2)).procesarFalla(anyString, any(Proceso))
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
		Assert.assertFalse(baseUsuariosRota.ContieneAcciones(procesoAgregadoAcciones.acciones))
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

	@Test
	def fallaProcesoCompuesto() {
		terminalEjecutora.ejecutarProceso(procesoCompuesto)
		Assert.assertTrue(srvMails.contieneMail(terminalEjecutora.nombreTerminal))
		Assert.assertFalse(baseUsuariosRota.ContieneAcciones(procesoAgregadoAcciones.acciones))
		Assert.assertTrue(
			HistorialProcesos.instance.contieneErrorDeProceso(terminalEjecutora,
				procesoCompuesto.procesosSimples.get(2)))
		}

		@After
		def limpiarSingletons() {
			HistorialProcesos.instance.limpiar
		}

		@AfterClass
		def static borrarArchivo() {
			Files.delete(archivo)
		}

	}
	