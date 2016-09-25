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
    self.cambiarEstadoFav = function (id) {

        if(self.esFavorito(id)){
            _.remove(self.dameUsuarioSrv().listaFavoritos,function (num) {
                return num===id;
            });
            return false;
        }else{
            self.dameUsuarioSrv().listaFavoritos.push(id);
            return true;
        }

    };

    function transformarAComentario (jsonTarea){
        return POI.asComentario(jsonTarea);
    }

    
    self.actualizarDetallesVista = function (id,usuario,comentario,calificacion) {

        busquedasService.actualizarDetalles(usuario,function () {
            //HAY Q VER Q GAROMPA HAGO ACA

        });
        listaOpinion=[];
        busquedasService.actualizarComentario(id,usuario.nombreTerminal,comentario,calificacion,function (rsp) {
            listaOpinion= ( _.map(rsp.data.listaComentarios, transformarAComentario));
            self.comentario = "";
            self.calificacion= 0;

            var nuevo = _.find(poisList,function (poi) {
                return poi.id===id;
            });
            nuevo.listaComentarios = listaOpinion;


        });

    };

    self.verificarServicio = function (servicio) {

        if(servicio.nombre!==undefined){
            return servicio.nombre;
        }else{
            return servicio;
        }

    };

    self.calcularDistancia = function (latitudPoi,longitudPoi) {
        var usuario = serviceBusq.getUsuarioSrv();
        poiPuntos = new Point(latitudPoi,longitudPoi);
        return poiPuntos.distance(new Point(usuario.latitud,usuario.longitud));
    };
    self.calcularCalificacionGeneral = function (poi) {
        var sumatoria = _.sumBy(poi.listaComentarios, function (comment) {
            return _.toInteger(comment.calificacion);
        });
        return ( sumatoria / poi.listaComentarios.length );
    };

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle","busquedasService","$state"];