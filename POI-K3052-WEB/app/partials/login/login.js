angular.module('poi-app').config(function ($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise("/");

    $stateProvider
            .state('index.login', {
                url: "/",
                templateUrl: "app/partials/login/login.html"
            });
    })
.controller('LoginController', function () {

    this.usuario = "";
    this.pass = "";

    this.validar = function () {
        if(this.usuario==="" || this.pass===""){
            throw "Complete todos los datos";
        }
        else if (this.usuario !== "ADMIN"){
            throw "El usuario no existe";
        }
        else if (this.pass!=="123"){
            throw "Contraseña incorrecta";
        }
    };
    this.loguearse = function(){
        try{
            this.validar();
            this.errorMessage=null;
            return true;
        }
        catch (exception){
            this.errorMessage=exception;
            return false;
        }
    }

});
