poiApp.service('busquedasService', function($http) {
    this.mandarLista = function(lista,callback) {
        $http.post('/paginas',lista).then(callback);
    };
    this.actualizarDetalles = function(usuario,callback) {
        $http.put('/verdetalles/',usuario).then(callback);
    };
    this.actualizarComentario = function (id,usuario,comentario,calificacion,callback) {
        $http.put('/verdetalles/' +id,{usuario:usuario,detalle:comentario,calificacion:calificacion}).then(callback);
    };
});



