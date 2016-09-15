app.service('busquedasService', function($http) {
    this.mandarLista = function(lista,callback) {
        $http.post('/paginas',"EstaPorongaNoAnda").then(callback);
    }


});