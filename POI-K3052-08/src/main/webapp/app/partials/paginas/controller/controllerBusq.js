function busquedaController(busqueda) {
	var self = this;

	self.busquedas = busqueda;
	self.criterios = criterios;
	self.listaResultados = listaResultados;


	self.buscarPorCriterio = function() {


//[{"id":2,"nombre":"Don José","direccion":"Quintana 861","latitud":10.0,"longitud":5.0,"tags":["José","Rotiseria","Barato"],"habilitado":true,"rubro":{"radioCercania":5.0,"nombre":"Rotiseria","horario":[],"diasAbierto":[]},"new":false},
//{"id":3,"nombre":"Don Yoyo","direccion":"Quintana 130","latitud":10.0,"longitud":5.0,"tags":["Yoyo","Librería","Barato"],"habilitado":true,"rubro":{"radioCercania":5.0,"nombre":"Librería","horario":[],"diasAbierto":[]},"new":false}]


        var esta = function(vec, criterio) {
			return _.includes(vec, criterio);
		};

		var x;
		var filtrado = [];

		self.listaResultados = [];
		for (x = 0; x < self.criterios.length; x++) {
			filtrado = _
					.filter(
							self.busquedas,
							function(i) {
								return (i.nombre
										.includes(self.criterios[x].nombre)
										|| i.direccion
												.includes(self.criterios[x].nombre)
										|| esta(i.tipo.rubros,
												self.criterios[x].nombre)
										|| esta(i.tipo.servicios,
												self.criterios[x].nombre) || esta(
										i.tipo.linea, self.criterios[x].nombre));
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



/*	self.damePOIS = function (){

		busquedasService.recibirPOIS(function (response){
			self.listaPOI.push(response);
		});

	}*/

    function transformarAPOI(jsonTarea) {
        return POI.asPOI(jsonTarea);
    }


    self.enviarListaCriterios = function (){

        self.listaPOI = [];
        busquedasService.mandarLista(self.criterios,function(rsp) {
            self.listaPOI = _.map(rsp.data, transformarAPOI);
            return self.listaPOI;
        });

    }

    self.agregarCriterio = function() {
        if (_.find(self.criterios, {
                nombre : self.nuevoCriterio
            }) === undefined && self.nuevoCriterio !== '') {
            self.criterios.push(new Criterio(self.nuevoCriterio));
        }
        self.nuevoCriterio = '';
        self.enviarListaCriterios();

    };
	self.limpiarCriterios = function() {
		self.criterios.length = 0;
	};
	self.eliminarCriterio = function(nombre) {
		_.remove(self.criterios, function(actual) {
			return (actual.nombre === nombre);
		})

	};


}



poiApp.controller("criterioController", ["criterios","busquedasService","$rootScope", function (criterio,busquedasService,$rootScope) {
    return new criterioController(criterio,busquedasService,$rootScope);
}]);


poiApp.controller("resultadosController", ["resultados",function (resultado) {
    return new busquedaController(resultado);
}]);
