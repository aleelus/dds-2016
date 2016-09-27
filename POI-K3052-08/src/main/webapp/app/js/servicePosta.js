poiApp.service('busquedasService', function($http) {
    this.mandarLista = function(lista,callback,errorHandler) {
        $http.post('/paginas',lista).then(callback,errorHandler);
    };
    this.actualizarDetalles = function(usuario,callback,errorHandler) {
        $http.put('/verdetalles/',usuario).then(callback,errorHandler);
    };
    this.actualizarComentario = function (id,usuario,comentario,calificacion,callback,errorHandler) {
        $http.put('/verdetalles/' +id,{usuario:usuario,detalle:comentario,calificacion:calificacion}).then(callback,errorHandler);
    };
});



