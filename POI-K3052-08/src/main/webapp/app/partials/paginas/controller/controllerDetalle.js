function detalleController(serviceBusq,detalle) {
    var self = this;
    self.detalle = detalle;

};

poiApp.controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle" ];