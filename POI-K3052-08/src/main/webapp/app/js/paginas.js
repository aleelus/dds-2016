poiApp.config(function ($stateProvider,$locationProvider) {
        return $stateProvider
            .state('index.busqueda', {
                url: "/paginas",
                templateUrl: "app/partials/paginas/vistas/busqueda.html",
                controller: "criterioController",
                controllerAs: "criterioCtrl",
                resolve: {
                    criterios: function (serviceBusq) {
                        return serviceBusq.getAllCriterios();
                    }
                }
            })
            .state('index.busqueda.resultados', {
                views: {
                    'resultados': {
                        url: "/resultados/",
                        templateUrl: "app/partials/paginas/vistas/resultados.html",
                        controller: "resultadosController",
                        controllerAs: "resultadoCtrl",
                        resolve: {
                            criterios: function (serviceBusq) {
                                return serviceBusq.getAllCriterios();
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
            })
            .state('index.ver_detalles.opinion', {
                views: {
                    'opinion': {
                        url: "/verdetalles/",
                        templateUrl: "app/partials/paginas/vistas/opiniones.html",
                        controller: "opinionController",
                        controllerAs: "opinionCtrl"
                    }
                }
            });

        $locationProvider.html5Mode(true);
    });