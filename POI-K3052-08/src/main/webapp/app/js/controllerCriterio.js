function criterioController(criterio, busquedasService,serviceBusq,$timeout) {
    var self = this;
    self.criterios = criterio;
    self.nuevoCriterio = '';
    self.timeout = $timeout;
    self.errors = [];


    self.dameUsuarioSrv = function () {
        return serviceBusq.getUsuarioSrv();
    };

    function transformarAPOI(jsonPOI) {
        return POI.asPOI(jsonPOI);
    }


    self.enviarListaCriterios = function (){


        busquedasService.mandarLista(self.criterios,function(rsp) {
            poisList = _.map(rsp.data, transformarAPOI);
            return poisList;
        },function () {
            notificarError(self);
        });

    };

    self.getListaCriterio=function () {
        return self.criterios;
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


poiApp.controller("criterioController", ["criterios","busquedasService","serviceBusq","$timeout" ,function (criterio,busquedasService,serviceBusq,$timeout) {
    return new criterioController(criterio,busquedasService,serviceBusq,$timeout);
}]);
