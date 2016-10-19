package puntosDeInteres

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import java.util.ArrayList
import java.util.List
import javax.persistence.Column
import javax.persistence.ElementCollection
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.DateTime
import org.uqbar.commons.utils.Observable
import org.uqbar.geodds.Point

@Accessors
@Observable
@Entity
@JsonIgnoreProperties(ignoreUnknown = true)
@Inheritance(strategy=InheritanceType.JOINED)
class POI{

	/////////////////////////
	@Id
    @GeneratedValue
    private Integer id
	/////////////////////////

	// Campos
	/**Nombre del punto de interés */
	@Column(length=100)
	String nombre
	/**Dirección del punto de interés */
	@Column(length=150)
	String direccion
	/**Latitud del punto de interés */
	@Column
	double latitud
	/**Longitud del punto de interés */
	@Column
	double longitud
	/**Palabras clave del punto de interés */
	@ElementCollection 	
	List<String> tags = new ArrayList<String>
	/**Estado del punto de interés */
	@Column
	Boolean habilitado = true;
	/**Lista de comentarios */
	@OneToMany(fetch=FetchType.LAZY)
	List<Comentario> listaComentarios = new ArrayList<Comentario> 
	/**URL del icono **/
	@Column(length=255)
	String urlIcono

	new() {
		
	}
	

	enum Dias {

		lunes,
		martes,
		miercoles,
		jueves,
		viernes,
		sabado,
		domingo
	}

	// Métodos
	/**Método que indica si una punto de interés genérico
	 * está cerca de una latitud y longitud determinados.
	 */
	def estaCerca(double latitudUser, double longitudUser) {
		val Point puntoUsuario = new Point(latitudUser, longitudUser)
		val Point puntoPOI = new Point(latitud, longitud)
		puntoPOI.distance(puntoUsuario) / 10 <= 5
	}

	/**Método que verifica si un input está contenido en el nombre del POI */
	def contieneTexto(String input) {
		estaHabilitado && (nombre.contains(input) || contieneTextoEnTags(input)) 
	}
	
	def estaHabilitado() {
		this.habilitado==true
	}
	
	/**Método que verifica si un input está en los tags */
	def contieneTextoEnTags(String input) {
		tags.exists[tag | tag.contains(input)] || direccion.contains(input)
	}

	def buscarDia(List<Dias> lista, Dias dia) {
		if (lista.findFirst[diaLista|diaLista == dia] != null)
			return true
	}

	def evaluarRangoHorario(List<DateTime> lista, int horaActual, int minActual) {

		val int[] x = newIntArrayOfSize(lista.size)
		val horario = horaActual * 100 + minActual

		lista.forEach[dt, c|x.set(c, dt.getHourOfDay() * 100 + dt.getMinuteOfHour())]

		for (var i = 0; i < x.size; i++) {
			if (x.get(i) <= horario && horario <= x.get(i + 1)) {
				return true
			} else {
				i++
			}
		}
		false
	}

	def setearDatos(POI poi) {
		nombre = poi.nombre
		latitud = poi.latitud
		longitud = poi.longitud
		tags = poi.tags
	}

	def validateCreate() {
		if (nombre.nullOrEmpty) {
			throw new Exception("Por favor introducir un nombre para el Punto de Interés")
		}
		if (this.latitud == 0 && this.longitud == 0) {
			throw new Exception("Por favor introducir una latitud y longitud para el Punto de Interés")
		}
	}

//	override equals(Object arg0) {
//		val POI puntoAComparar = arg0 as POI
//		(nombre.equals(puntoAComparar.nombre) && direccion.equals(puntoAComparar.direccion)) || (id.equals(puntoAComparar.id))
//	}

//	override hashCode() {
//		id
//	}
	
	def inhabilitar() {
		this.habilitado = false
	}
	
	def verificarSiEseUsuarioComento(Comentario comentario){
		listaComentarios.exists[comment| comment.usuario.contains(comentario.usuario)]		
	}
	
	def addComentario (Comentario comentario){
		
		if(!this.verificarSiEseUsuarioComento(comentario)){
			listaComentarios.add(new Comentario(comentario.usuario,comentario.detalle,comentario.calificacion))
		}
		
		
	}

}


@Accessors
@Entity
@JsonIgnoreProperties(ignoreUnknown = true)
class Comentario{
	
	@Id
    @GeneratedValue
    private Integer id
	@Column(length=100)
	String usuario
	@Column(length=200)
	String detalle
	@Column(length=5)
	String calificacion
	
	new() {
		
	}
	
	
	new(String terminal, String comentario, String calificacion) {
		this.usuario = terminal
		this.detalle = comentario
		this.calificacion = calificacion
	}
		
}
