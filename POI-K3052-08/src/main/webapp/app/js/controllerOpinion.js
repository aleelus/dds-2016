function opinionController (serviceBusq){

    var self = this;


    self.dameListaOpiniones = function () {
        return serviceBusq.getListaOpinion();

    };

};


poiApp.controller("opinionController", ["serviceBusq",function (serviceBusq) {
    return new opinionController(serviceBusq);
}]);