poiApp.config(function ($stateProvider,$locationProvider) {
        return $stateProvider
            .state('index.busqueda', {
                url: "/paginas",
                templateUrl: "app/partials/paginas/vistas/busqueda.html",
                controller: "criterioController",
                controllerAs: "criterioCtrl",
                resolve: {
                    criterios: function (serviceBusq) {
                        return serviceBusq.getAllCriterios()
                    }
                }
            })
            .state('index.busqueda.resultados', {
                views: {
                    'resultados': {
                        templateUrl: "app/partials/paginas/vistas/resultados.html",
                        controller: "resultadosController",
                        controllerAs: "resultadoCtrl",
                        resolve: {
                            resultados: function (serviceBusq) {
                                  return serviceBusq.getAll()
                            },
                            criterios: function (serviceBusq) {
                                return serviceBusq.getAllCriterios()
                            }
                        }
                    }
                }
            })
            .state('index.ver_detalles', {
                url: "/verdetalles/:id",
                templateUrl: "app/partials/paginas/vistas/verDetalles.html",
                controller: "detalleController",
                controllerAs: "detalleCtrl",
                resolve: {
                    detalle: function (serviceBusq, $stateParams) {
                        return serviceBusq.get(parseInt($stateParams.id));
                    }
                }
            });
        
        $locationProvider.html5Mode(true);
    });