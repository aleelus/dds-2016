function criterioController(criterio, busquedasService,$rootScope) {
    var self = this;
    self.criterios = criterio;
    self.nuevoCriterio = '';

    function transformarAPOI(jsonTarea) {
        return POI.asPOI(jsonTarea);
    }


    self.enviarListaCriterios = function (){


        busquedasService.mandarLista(self.criterios,function(rsp) {
            poisList = _.map(rsp.data, transformarAPOI);
            return poisList;
        });

    };

    self.agregarCriterio = function() {
        if (_.find(self.criterios, {
                nombre : self.nuevoCriterio
            }) === undefined && self.nuevoCriterio !== '') {
            self.criterios.push(new Criterio(self.nuevoCriterio));
            self.nuevoCriterio = '';
            self.enviarListaCriterios();

        }


    };
    self.limpiarCriterios = function() {
        self.criterios.length = 0;
    };
    self.eliminarCriterio = function(nombre) {
        _.remove(self.criterios, function(actual) {
            return (actual.nombre === nombre);
        });

    };

}


poiApp.controller("criterioController", ["criterios","busquedasService","$rootScope", function (criterio,busquedasService,$rootScope) {
    return new criterioController(criterio,busquedasService,$rootScope);
}]);
