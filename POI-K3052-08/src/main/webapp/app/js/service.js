function Criterio(nombre){

    return {nombre: nombre};
}

criterios = [];
listaResultados = [];
poisList = [];


function serviceBusq() {
    var self = this;

    self.getAllCriterios = function () {
        return criterios;
    };

    self.get = function (id) {
        return _.find(poisList, { id: id });
    };



};

angular.module("poi-app")
    .factory("serviceBusq", function() {
        return new serviceBusq();
    });

poiApp.service('loginService',function ($http) {
    this.validarUsuario = function (usuario,contraseña,callback) {
        $http.post('/',{nombreTerminal:usuario,contraseña:contraseña}).then(callback)
    }
    
})