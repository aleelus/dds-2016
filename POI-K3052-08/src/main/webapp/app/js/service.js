function Criterio(nombre){

    return {nombre: nombre};
}

criterios = [];
listaResultados = [];
poisList = [];
listaOpinion = [];


function serviceBusq() {
    var self = this;
    self.usuarioSrv = undefined;
    
    self.getAllCriterios = function () {
        return criterios;
    };
    self.getListaOpinion = function () {
        return listaOpinion;
    };
    self.setListaOpinion = function (lista) {
        self.listaOpinion = lista;
    };

    self.get = function (id) {
        var lista =_.find(poisList, { id: id });
        listaOpinion=[];
        listaOpinion = lista.listaComentarios;
        return lista
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

    self.favorito = function (id) {
        return _.includes(self.getUsuarioSrv().listaFavoritos,id);
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