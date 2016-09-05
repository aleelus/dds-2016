function busquedaController(busqueda) {
    var self = this;
    self.busquedas = busqueda;

}
function criterioController(criterio) {
    var self = this;
    self.criterios = criterio;

}

var x = angular.module("poi-app");

x.controller("criterioController", ["criterios", function (criterio) {
    return new criterioController(criterio);
}]);

x.controller("resultadosController", ["resultados", function (resultado) {
    return new busquedaController(resultado);
}]);