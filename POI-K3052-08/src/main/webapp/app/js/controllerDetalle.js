function detalleController(serviceBusq,detalle,busquedasService,$timeout) {
    var self = this;
    self.detalle = detalle;
    self.comentario = "";
    self.calificacion= 0;
    self.timeout = $timeout;
    self.errors = [];
    self.msgError ="";

    self.hayDatos = function (datos){
        return  (datos !==undefined);
    };

    self.dameUsuarioSrv = function () {
        return serviceBusq.getUsuarioSrv();
    };

    self.esFavorito = function (id) {
        return serviceBusq.favorito(id);
    };
    self.cambiarEstadoFav = function (poi) {
        return self.dameUsuarioSrv().esFavoritoDe(self.dameUsuarioSrv(),poi,self.esFavorito);
    };

    function transformarAComentario (jsonComentario){
        return Comentario.asComentario(jsonComentario);
    }


    self.actualizarDetallesVista = function (poi, usuario, comentario, calificacion) {


        busquedasService.actualizarDetalles(usuario, function () {


        }, function () {
            notificarError(self);
        });


        if (comentario !== "" && calificacion !== 0) {
            listaOpinion = [];
            busquedasService.actualizarComentario(poi.id, usuario.nombreTerminal, comentario, calificacion, function (rsp) {
                listaOpinion = ( _.map(rsp.data.listaComentarios, transformarAComentario));
                poi.agregarComentario(poi);
                self.comentario = "";
                self.calificacion = 0;
            }, function () {
                notificarError(self);
            });
            self.msgError="Los cambios han sido guardados. Gracias por comentar y calificar nuestro servicio.";

        }else{
            self.msgError = "Los cambios han sido guardados. No se ha comentado ni calificado a este POI.";
        }


    };

    self.verificarServicio = function (servicio) {

        if(servicio.nombre!==undefined){
            return servicio.nombre;
        }else{
            return servicio;
        }

    };

    self.calcularDistancia = function (poi) {
        var usuario = serviceBusq.getUsuarioSrv();
        return poi.calcularDistanciaPOI(poi,usuario);
    };
    self.calcularCalificacionGeneral = function (poi) {
        var resultado = poi.calcularCalificacion(poi);
        if(resultado>0){
            return resultado + " /5";
        }
        return resultado;
    };

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle","busquedasService","$state","$timeout"];