function Criterio(nombre){

    return {nombre: nombre};
}

criterios = [];
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
        return lista;
    };

    self.limpiar = function() {
        criterios.length = 0;
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

