function resultadosController(serviceBusq) {
	var self = this;
	self.criterios = criterios;


    self.getPoiLista = function (){
        return poisList;
    };

	self.esFavorito = function (id) {
        return serviceBusq.favorito(id);
    };

}

poiApp.controller("resultadosController", ["serviceBusq",function (serviceBusq) {
    return new resultadosController(serviceBusq);
}]);

