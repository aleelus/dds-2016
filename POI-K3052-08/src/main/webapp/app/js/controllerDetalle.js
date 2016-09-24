function detalleController(serviceBusq,detalle,busquedasService) {
    var self = this;
    self.detalle = detalle;

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

    self.actualizarDetallesVista = function (usuario) {

        busquedasService.actualizarDetalles(usuario,function () {
            //HAY Q VER Q GAROMPA HAGO ACA
            $state.go("index.ver_detalles");
        });

    };

    self.verificarServicio = function (servicio) {

        if(servicio.nombre!==undefined){
            return servicio.nombre;
        }else{
            return servicio;
        }

    };

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle","busquedasService" ];