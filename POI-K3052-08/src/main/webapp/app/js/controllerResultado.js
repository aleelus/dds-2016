function resultadosController(busqueda) {
	var self = this;

	self.busquedas = busqueda;
	self.criterios = criterios;
    self.listaResultados = listaResultados;


    self.getPoiLista = function (){
        return poisList;
    };

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

poiApp.controller("resultadosController", [function (busqueda) {
    return new resultadosController(busqueda);
}]);
