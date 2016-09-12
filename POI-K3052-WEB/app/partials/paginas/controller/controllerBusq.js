function busquedaController(busqueda) {
    var self = this;

    self.busquedas = busqueda;
    self.criterios = criterios;

    self.buscarPorCriterio = function (criterio) {

        var esta = function (vec) {
            return _.includes(vec, criterio);
        };
        return _.filter(self.busquedas, function (i) {
            return (i.nombre.includes(criterio) || i.direccion.includes(criterio) || esta(i.tipo.rubros) || esta(i.servicios) || esta(i.tipo.linea));
        })
    };

}
function criterioController(criterio) {
    var self = this;
    self.criterios = criterio;
    self.nuevoCriterio = '';

    self.agregarCriterio = function () {
        if (_.find(self.criterios, {nombre: self.nuevoCriterio}) === undefined) {
            self.criterios.push(new Criterio(self.nuevoCriterio));
        }
        self.nuevoCriterio = '';

    };
    self.limpiarCriterios = function () {
        self.criterios.length = 0;
    };
    self.eliminarCriterio = function (nombre) {
        _.remove(self.criterios, function (actual) {
            return (actual.nombre === nombre);
        })
    };

    self.setValue = function (criterio) {
        $scope.criterioSeleccionado = criterio;
    }
}

var x = angular.module("poi-app");

x.controller("criterioController", ["criterios", function (criterio) {
    return new criterioController(criterio);
}]);

x.controller("resultadosController", ["resultados", function (resultado) {
    return new busquedaController(resultado);
}]);