function busquedaController(busqueda) {
    var self = this;
    self.busquedas = busqueda;



}

angular.module("poi-app")
    .controller("busquedaController", [ "busquedas", function(busquedas) {
        return new busquedaController(busquedas);
    }]);