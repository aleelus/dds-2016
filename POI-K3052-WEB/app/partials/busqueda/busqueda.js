angular.module('poi-app')
    .config(function ($stateProvider) {
        return $stateProvider
            .state('index.busqueda', {
                url: "/busqueda",
                templateUrl: "app/partials/busqueda/vistas/busqueda.html",
                controller: "busquedaController",
                controllerAs: "busqCtrl",
                resolve: {
                    busquedas: function (serviceBusq) {
                        return serviceBusq.getAll()
                    }
                }
            })
            .state('index.ver_detalles', {
                url: "/busqueda/verdetalles/:id",
                templateUrl: "app/partials/busqueda/vistas/verDetalles.html",
                controller: "detalleController",
                controllerAs: "detalleCtrl",
                resolve: {
                    detalle: function (serviceBusq,$stateParams) {
                        return serviceBusq.get(parseInt($stateParams.id));
                    }
                }
            });
    });