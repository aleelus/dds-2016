
function busquedaController(busqueda) {
	var self = this;

	self.busquedas = busqueda;
	self.criterios = criterios;
    self.listaResultados = listaResultados;


    self.getPoiLista = function (){
        return poisList;
    };

//[{"id":2,"nombre":"Don José","direccion":"Quintana 861","latitud":10.0,"longitud":5.0,"tags":["José","Rotiseria","Barato"],"habilitado":true,"rubro":{"radioCercania":5.0,"nombre":"Rotiseria","horario":[],"diasAbierto":[]},"new":false},
//{"id":3,"nombre":"Don Yoyo","direccion":"Quintana 130","latitud":10.0,"longitud":5.0,"tags":["Yoyo","Librería","Barato"],"habilitado":true,"rubro":{"radioCercania":5.0,"nombre":"Librería","horario":[],"diasAbierto":[]},"new":false}]

	self.buscarPorCriterio = function() {



        var esta = function(vec, criterio) {
			return _.includes(vec, criterio);
		};

		var x;
		var filtrado = [];

        // || i.rubro.nombre.includes(self.criterios[x].nombre) || esta(i.servicios,self.criterios[x].nombre)

        self.listaResultados= [];
        for (x = 0; x < self.criterios.length; x++) {
            filtrado = _.filter(self.getPoiLista(),function (i) {
                        return (i.nombre.includes(self.criterios[x].nombre) || i.direccion.includes(self.criterios[x].nombre)
                        )
                        });
            self.listaResultados = _.union(filtrado, self.listaResultados);

        }

		return self.listaResultados;
	};

}
function criterioController(criterio, busquedasService,$rootScope) {
	var self = this;
	self.criterios = criterio;
	self.nuevoCriterio = '';
    //self.poisList = poisList;



/*	self.damePOIS = function (){

		busquedasService.recibirPOIS(function (response){
			self.listaPOI.push(response);
		});

	}*/

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


poiApp.controller("resultadosController", [function (busqueda) {
    return new busquedaController(busqueda);
}]);
