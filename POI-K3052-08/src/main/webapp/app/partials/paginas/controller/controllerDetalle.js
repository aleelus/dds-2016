function detalleController(serviceBusq,detalle) {
    var self = this;
    self.detalle = detalle;

    self.hayDatos = function (datos){
        return  ( datos.hasOwnProperty("rubro") || datos.hasOwnProperty("servicios") ||  datos.hasOwnProperty("lineas") )  ;
    };

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle" ];