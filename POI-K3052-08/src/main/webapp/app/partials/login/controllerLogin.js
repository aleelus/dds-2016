angular.module('poi-app').config(function ($stateProvider, $urlRouterProvider,$locationProvider) {
    $urlRouterProvider.otherwise("/");

    $stateProvider
        .state('index.login', {
            url: "/",
            templateUrl: "app/partials/login/login.html"
        });
    $locationProvider.html5Mode(true);
})
    .controller('LoginController', function (loginService) {

        var self = this;

        this.usuario = "";
        this.pass = "";

        this.validar = function () {
            if (self.usuario === "" || self.pass === "") {
                throw "Complete todos los datos";
            } else {
                loginService.validarUsuario(self.usuario,self.pass,function (response) {
                    self.loginCorrecto = response.data;
                    if (!self.loginCorrecto){
                        throw response.data;
                    }
                });
            }
        };

        this.loguearse = function () {
            try {
                this.validar();
                this.errorMessage = null;
                return true;
            }
            catch (exception) {
                this.errorMessage = exception.toString();
                return false;
            }
        }

    });
