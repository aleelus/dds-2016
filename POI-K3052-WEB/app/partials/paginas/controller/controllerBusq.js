function busquedaController(busqueda) {
    var self = this;

    self.busquedas = busqueda;
    self.criterios = criterios;

    self.buscarPorCriterio = function (criterio){

        var i=0;

        var esta = function (vec){
           /* var x;
            for(x=0;x<vec.length;x++){
                if(vec[x]===criterio){
                    return true;
                }
            }*/
            return false;
        };

        for(i=0;i<self.busquedas.length;i++){
            if(self.busquedas[i].nombre===criterio || self.busquedas[i].direccion===criterio || esta(self.busquedas[i].tipo.linea)){
                return self.busquedas[i];
            }
        }

    };

}
function criterioController(criterio) {
    var self = this;
    self.criterios = criterio;
    self.nuevoCriterio = '';

    self.agregarCriterio = function() {
        if (_.find(self.criterios, {nombre: self.nuevoCriterio}) === undefined) {
            self.criterios.push(new Criterio(self.nuevoCriterio));
        }
        self.nuevoCriterio= '';

    };
    self.limpiarCriterios = function(){
        self.criterios.length = 0;
    };
    self.eliminarCriterio = function(nombre){
        _.remove(self.criterios,function(actual){
            return (actual.nombre===nombre);
        })
    };

}

var x = angular.module("poi-app");

x.controller("criterioController", ["criterios", function (criterio) {
    return new criterioController(criterio);
}]);

x.controller("resultadosController", ["resultados", function (resultado) {
    return new busquedaController(resultado);
}]);