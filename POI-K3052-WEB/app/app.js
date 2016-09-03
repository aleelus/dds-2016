'use strict';

angular.module('poi-app', ['ui.router'])
    .config(function ($urlRouterProvider, $locationProvider) {
        $urlRouterProvider.otherwise('/');
        return $locationProvider.html5Mode(true);
    })
.config(function ($stateProvider) {
    return $stateProvider
        .state('index',{
            abstract:true,
            views: {
                'layout': {
                    templateUrl: "app/layout/layout.html"
                },
                'topbar': {
                    templateUrl: "app/layout/topbar.html"
                },
                'container@index': {
                    template: "<ui-view>"
                }
            }
        })
})