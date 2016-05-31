package interfazUsuario

class Rol {
	boolean notificacionesAutorizadas
	boolean reportesAutorizados

	new() {
		super()
	}

	new(boolean autorizacionNotif, boolean autorizacionReportes) {
		this()
		this.notificacionesAutorizadas = autorizacionNotif
		this.reportesAutorizados = autorizacionReportes
	}

	def accesoTotal() {
		notificacionesAutorizadas = true
		reportesAutorizados = true
	}

	def estaAutorizadoAEmitirNotificaciones() {
		notificacionesAutorizadas
	}

	def estaAutorizadoAEmitirReportes() {
		reportesAutorizados
	}
	
	def accesoParcial() {
		notificacionesAutorizadas = true
		reportesAutorizados = false
	}
	
	def sinAcceso() {
		notificacionesAutorizadas = false
		reportesAutorizados = false
	}
}