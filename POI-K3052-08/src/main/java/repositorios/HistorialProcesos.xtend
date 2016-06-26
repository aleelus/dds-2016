package repositorios

import interfazUsuario.Terminal
import org.apache.commons.collections15.Predicate
import org.apache.commons.collections15.functors.AndPredicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.commons.model.CollectionBasedRepo
import org.uqbar.commons.model.Entity
import procesos.ProcSimple

class HistorialProcesos extends CollectionBasedRepo<DatosProceso> {

	/**Instancia del Singleton */
	private static HistorialProcesos instancia = new HistorialProcesos()

	/**Defino un constructor vacío */
	private new() {
	}

	def static getInstance() {
		instancia
	}

	def agregarProceso(DatosProceso datos) {
		this.create(datos)
	}

	def contieneAOK(Terminal terminal) {
		allInstances.exists [ resultado |
			resultado.resultado.equals(ResultadoProceso.OK) && resultado.usuario.equals(terminal.nombreTerminal)
		]
	}

	def contieneAError(Terminal terminal) {
		allInstances.exists [ resultado |
			resultado.resultado.equals(ResultadoProceso.ERROR) && resultado.usuario.equals(terminal.nombreTerminal)
		]
	}

	def contieneErrorDeProceso(Terminal terminal, ProcSimple proceso) {
		allInstances.exists [ resultado |
			resultado.resultado.equals(ResultadoProceso.ERROR) && resultado.usuario.equals(terminal.nombreTerminal) &&
				resultado.proceso.equals(proceso.nombre)
		]
	}

	def limpiar() {
		allInstances.clear
	}

	override protected Predicate<DatosProceso> getCriterio(DatosProceso dato) {
		var resultado = this.criterioTodas
		if (dato.proceso != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorProceso(dato.proceso))
		}
		if (dato.usuario != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorUsuario(dato.usuario))
		}
		if (dato.resultado != null) {
			resultado = new AndPredicate(resultado, this.getCriterioPorResultado(dato.resultado))
		}
		resultado
	}

	override protected getCriterioTodas() {
		[DatosProceso resultado|true] as Predicate<DatosProceso>
	}

	def getCriterioPorProceso(String nomProc) {
		[DatosProceso dato|dato.proceso.equals(nomProc)] as Predicate<DatosProceso>
	}

	def getCriterioPorUsuario(String nomUser) {
		[DatosProceso dato|dato.usuario.equals(nomUser)] as Predicate<DatosProceso>
	}

	def getCriterioPorResultado(ResultadoProceso resul) {
		[DatosProceso dato|dato.resultado.equals(resul)] as Predicate<DatosProceso>
	}

	override createExample() {
		new DatosProceso
	}

	override getEntityType() {
		typeof(DatosProceso)
	}

}

@Accessors
class DatosProceso extends Entity {
	DateTime tiempoEjecucion
	DateTime tiempoFinalizacion
	String proceso
	String usuario
	ResultadoProceso resultado
	String mensajeError = new String("")

	new(DateTime ejecucion, DateTime finalizacion, String tipoProceso, String user, ResultadoProceso resultadoProceso) {
		super()
		this.tiempoEjecucion = ejecucion
		this.tiempoFinalizacion = finalizacion
		this.proceso = tipoProceso
		this.usuario = user
		this.resultado = resultadoProceso
	}

	new(DateTime ejecucion, DateTime finalizacion, String tipoProceso, String user, ResultadoProceso resultadoProceso,
		String mensajeError) {
		super()
		this.tiempoEjecucion = ejecucion
		this.tiempoFinalizacion = finalizacion
		this.proceso = tipoProceso
		this.usuario = user
		this.resultado = resultadoProceso
		this.mensajeError = mensajeError
	}

	new() {
		super()
	}

}

enum ResultadoProceso {
	OK,
	ERROR
}
