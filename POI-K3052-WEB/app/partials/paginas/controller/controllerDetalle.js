function detalleController(serviceBusq,detalle) {
    var self = this;
    self.detalle = detalle;

};

angular.module("poi-app")
    .controller("detalleController", detalleController);

detalleController.$inject = [ "serviceBusq", "detalle" ];