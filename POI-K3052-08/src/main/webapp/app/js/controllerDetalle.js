function detalleController(serviceBusq,detalle,busquedasService,$state) {
    var self = this;
    self.detalle = detalle;
    self.comentario = "";
    self.calificacion= 0;

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

    function transformarAComentario (jsonTarea){
        return Comentario.asComentario(jsonTarea);
    }

    
    self.actualizarDetallesVista = function (poi,usuario,comentario,calificacion) {

        busquedasService.actualizarDetalles(usuario,function () {
            //HAY Q VER Q GAROMPA HAGO ACA

        });
        listaOpinion=[];
        busquedasService.actualizarComentario(poi.id,usuario.nombreTerminal,comentario,calificacion,function (rsp) {
            listaOpinion= ( _.map(rsp.data.listaComentarios, transformarAComentario));
            poi.agregarComentario(poi);
            self.comentario = "";
            self.calificacion= 0;
        });

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
        return poi.calcularCalificacion(poi);
    };

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle","busquedasService","$state"];