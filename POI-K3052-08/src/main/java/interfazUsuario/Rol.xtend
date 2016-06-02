package interfazUsuario

class Rol {
	boolean notificacionesAutorizadas
	boolean reportesAutorizados
	boolean procesosAutorizados

	new() {
		super()
	}

	new(boolean autorizacionNotif, boolean autorizacionReportes, boolean autorizacionProcesos) {
		this()
		this.notificacionesAutorizadas = autorizacionNotif
		this.reportesAutorizados = autorizacionReportes
		this.procesosAutorizados = autorizacionProcesos
	}

	def esAdmin() {
		notificacionesAutorizadas = true
		reportesAutorizados = true
		procesosAutorizados = true
	}

	def estaAutorizadoAEmitirNotificaciones() {
		notificacionesAutorizadas
	}

	def estaAutorizadoAEmitirReportes() {
		reportesAutorizados
	}
	
	def esUserConNotificacion() {
		notificacionesAutorizadas = true
		reportesAutorizados = false
		procesosAutorizados = false
	}
	
	def esUserSinNotificacion() {
		notificacionesAutorizadas = false
		reportesAutorizados = false
		procesosAutorizados = false
	}
	
	def estaAutorizadoAEjecutarProcesos() {
		procesosAutorizados
	}
	
}