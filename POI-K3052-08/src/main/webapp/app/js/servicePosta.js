poiApp.service('busquedasService', function($http) {
    this.mandarLista = function(lista,callback) {
        $http.post('/paginas',lista).then(callback);
    }
    this.recibirPOIS = function(callback) {
        $http.get('/paginas').then(callback);
    }
    this.actualizarDetalles = function(usuario,callback) {
        $http.put('/verdetalles/' +usuario.id,usuario).then(callback);
    }
});



