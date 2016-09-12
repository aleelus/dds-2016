function busquedaController(busqueda) {
    var self = this;

    self.busquedas = busqueda;
    self.criterios = criterios;
    self.listaResultados = listaResultados;

    self.buscarPorCriterio = function () {

        var esta = function (vec,criterio) {
            return _.includes(vec, criterio);
        };
        /*
        return _.filter(self.busquedas, function (i) {
            return (i.nombre.includes(criterio) || i.direccion.includes(criterio) || esta(i.tipo.rubros) || esta(i.servicios) || esta(i.tipo.linea));
        })*/

        //HAY Q VER BIEN DESPUES ESTA FUNCION
        var x;

        var filtrado = [];

        self.listaResultados=[];
        for(x=0;x<self.criterios.length;x++){
            filtrado = _.filter(self.busquedas, function (i) {
                return (i.nombre.includes(self.criterios[x].nombre) || i.direccion.includes(self.criterios[x].nombre) || esta(i.tipo.rubros,self.criterios[x].nombre) || esta(i.tipo.servicios,self.criterios[x].nombre) || esta(i.tipo.linea,self.criterios[x].nombre));
            });
            self.listaResultados=_.union(filtrado,self.listaResultados);

        }

        return self.listaResultados;
    };

}
function criterioController(criterio) {
    var self = this;
    self.criterios = criterio;
    self.nuevoCriterio = '';


    self.agregarCriterio = function () {
        if (_.find(self.criterios, {nombre: self.nuevoCriterio}) === undefined && self.nuevoCriterio!== '') {
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