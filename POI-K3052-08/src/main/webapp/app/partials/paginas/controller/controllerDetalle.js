function detalleController(serviceBusq,detalle) {
    var self = this;
    self.detalle = detalle;

    self.hayDatos = function (datos){
        return _.some(datos,'rubro');
    };

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle" ];