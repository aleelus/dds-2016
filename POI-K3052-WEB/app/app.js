'use strict';

var poiApp = angular.module('poi-app', ['ui.router'])
    .config(function ($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.otherwise("/");
        $stateProvider
            .state('index', {
                abstract: true,
                views: {
                    'layout': {
                        templateUrl: "app/layout/layout.html"
                    },
                    'topbar@index': {
                        templateUrl: "app/layout/topbar.html"
                    },
                    'container@index': {
                        template: "<ui-view>"
                    },

                },
            })
    })

    .directive('eatClickIf', ['$parse', '$rootScope',
        function ($parse, $rootScope) {
            return {
                // this ensure ejecutarSiEsFalso be compiled before ngClick
                priority: 100,
                restrict: 'A',
                compile: function ($element, attr) {
                    var fn = $parse(attr.eatClickIf);
                    return {
                        pre: function link(scope, element) {
                            var eventName = 'click';
                            element.on(eventName, function (event) {
                                var callback = function () {
                                    if (fn(scope, {$event: event})) {
                                        // prevents ng-click to be executed
                                        event.stopImmediatePropagation();
                                        // prevents href
                                        event.preventDefault();
                                        return false;
                                    }
                                };
                                if ($rootScope.$$phase) {
                                    scope.$evalAsync(callback);
                                } else {
                                    scope.$apply(callback);
                                }
                            });
                        },
                        post: function () {
                        }
                    }
                }
            }
        }
    ]);
poiApp.run(function ($state,$rootScope) {
    $rootScope.$state = $state;
})
