poiApp.config(function ($stateProvider, $urlRouterProvider,$locationProvider) {
    $urlRouterProvider.otherwise("/");

    $stateProvider
        .state('index.login', {
            url: "/",
            controller: "LoginController",
            controllerAs: "loginCtrl",
            templateUrl: "app/partials/login/login.html"
        });
    $locationProvider.html5Mode(true);
})
    .controller('LoginController', function (loginService,serviceBusq,$state) {

        var self = this;

        this.usuario = "";
        this.pass = "";
        this.respuesta= false;

        self.validar = function () {
            if (self.usuario === "" || self.pass === "") {
                throw "Complete todos los datos";
            } else {
                loginService.validarUsuario(self.usuario,self.pass,function (response) {
                    self.respuesta = response.data;
                    if(self.respuesta!== false){
                        serviceBusq.setUsuarioSrv(self.respuesta);
                        $state.go("index.busqueda");
                    }
                });
            }
        };

        self.loguearse = function () {
            try {
                self.validar();
                if (!self.respuesta) {
                    throw "Usuario o contraseña incorrectos";
                }
                return true;
            }
            catch (exception) {
                this.errorMessage = exception.toString();
                return false;
            }
        };

    });
