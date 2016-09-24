function Criterio(nombre){

    return {nombre: nombre};
}

criterios = [];
listaResultados = [];
poisList = [];


function serviceBusq() {
    var self = this;
    self.usuarioSrv = undefined;
    
    self.getAllCriterios = function () {
        return criterios;
    };

    self.get = function (id) {
        return _.find(poisList, { id: id });
    };

    self.limpiar = function() {
        criterios.length = 0;
        listaResultados.length =0;
        poisList.length = 0;
    };

    self.getUsuarioSrv = function () {
        return self.usuarioSrv;
    };
    self.setUsuarioSrv = function (usuario) {
        self.usuarioSrv = undefined;
        self.usuarioSrv = usuario;
    };


};

poiApp.factory("serviceBusq", function() {
        return new serviceBusq();
    });

poiApp.service('loginService',function ($http) {
    this.validarUsuario = function (usuario,contraseña,callback) {
        $http.post('/',{nombreTerminal:usuario,contraseña:contraseña}).then(callback)
    }
    
})