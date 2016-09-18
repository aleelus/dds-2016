

var idBusq=0;

/*
function Busqueda(nombre, direccion,tipo) {
    return { id: idBusq++, nombre: nombre, direccion: direccion, tipo: tipo};
}

busquedas = [
    new Busqueda("Centro Flores", "Av.Corrientes 2783",{ servicios: ["Cobro de impuestos","Servicio de licencias","Atencion al jubilado"]}),
    new Busqueda("Local Don José", "Quintana 861",{ rubros: ["Rotiseria"]}),
    new Busqueda("Local Don Yoyo", "Quintana 130",{ rubros: ["Librería"]}),
    new Busqueda("Parada de Colectivos", "Malabia 29",{ linea: ["124","164","4","12","3","8","101"]}),
    new Busqueda("Sucursal Banco Santander Rio", "Av.Rivadavia 3163",{ servicios: ["Cobro de cheques","Depositos","Transferencias","Extracciones"]}),
    new Busqueda("Sucursal Banco Nación", "Av.Independencia 3599",{ servicios: ["Transferencias","Extracciones"]})

];*/

function Criterio(nombre){

    return {nombre: nombre};
}

criterios = [];
listaResultados = [];
poisList = [];


function serviceBusq() {
    var self = this;

   /* self.getAll = function () {
        return busquedas;
    };*/

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
        $http.get('/',{user:usuario,pass:contraseña}).then(callback)
    }
    
})